function [acc, A, B, Zs, Zt, Yt0, Ps, Pt, YtP] = CPTML(DataArr,options)
Xs = DataArr.Xs;
Xt = DataArr.Xt;
Ys = DataArr.Ys;
Yt = DataArr.Yt;
m = size(Xs,1);
ns = size(Xs,2);
nt = size(Xt,2);

T = options.T;
ReducedDim = options.ReducedDim;
options.interK = floor(options.interK);
options.intraK = floor(options.intraK);
mu = options.mu;
lambda = options.lambda;
gamma = options.gamma;
lambdalib = options.lambdalib;

[P,~] = pca1(Xs',options);
[Yt0,PCAAcc] = myClassifier(Xs,Xt,Ys,Yt,P);
Ps = P'*Xs;
Pt = P'*Xt;
YtP = Yt0;
fprintf('PCA accuracy : %f\n',PCAAcc);

accVec = zeros(T,1);
accCount = 0;

[Lws,Lbs] = myConGraph2(Ys,options,Xs');
Sbs = Xs*Lbs*Xs';
Sws = Xs*Lws*Xs';
Ht = eye(nt) - (1/nt)*ones(nt,nt);
Sht = Xt*Ht*Xt';

    for i = 1:T
        [Lwt,Lbt] = myConGraph2(Yt0,options,Xt');
        Sbt = Xt*Lbt*Xt';
        Swt = Xt*Lwt*Xt';
        
        [g1,Hss,Htt,Hst,Hts] = constructH_modify(ns,nt,Ys,Yt0);

        Mss = Xs*Hss*Xs';
        Mtt = Xt*Htt*Xt';
        Mst = -Xs*Hst*Xt';
        Mts = -Xt*Hts*Xs';  

        Smax = [gamma*Sbs,zeros(m,m);zeros(m,m),gamma*Sbt+mu*Sht];
        Smin = [Mss+gamma*Sws+lambda*eye(m),Mst-lambda*eye(m);Mts-lambda*eye(m),Mtt+gamma*Swt+(lambda+mu)*eye(m)];
        [W,~] = eigs(Smax, Smin+eps*eye(2*m), ReducedDim, 'LM');   
        A = W(1:m, :);
        B = W(m+1:end, :);
        Zs = A'*Xs;
        Zt = B'*Xt;
                
        % LSR
        [acc, Yt0] = LSR(Zs, Ys, Zt, Yt, lambdalib);
        accVec(i) = acc;  
        
        if i>5 && accCount==15
            acc = accVec(i);
            break;
        elseif i>5 && accCount<15
            if accVec(i) == accVec(i-1)
                accCount = accCount + 1;
            else
                accCount = 0;
            end
        end
    end
end

function [y,acc] = myClassifier(Xs,Xt,Ys,Yt,p)
        X = [Xs,Xt];
        Z = p'*X;
        Z = Z*diag(sparse(1./sqrt(sum(Z.^2))));
        Zs = Z(:,1:size(Xs,2));
        Zt = Z(:,size(Xs,2)+1:end);
        D=EuDist2(Zt',Zs');
         [~,idx]=sort(D,2);
         y=Ys(idx(:,1),1);
         acc=length(find(y==Yt))/length(Yt);
         clear X Z Zs Zt D Xs Xt Ys Yt p
end