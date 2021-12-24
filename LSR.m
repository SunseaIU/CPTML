function [acc, Ypre] = LSR(X_src, Y_src, X_tar, Y_tar, lambda)
nc= length(unique(Y_src)); 
[~,nt] = size(X_tar);
[d,ns] = size(X_src);

% X_src = NormalizeFea(X_src,2); 
% X_tar = NormalizeFea(X_tar,2); 

X_src = X_src-repmat(mean(X_src,2),[1,ns]);
X_tar = X_tar-repmat(mean(X_tar,2),[1,nt]);

% dataset = [X_src'; X_tar'];
% [dataset_scale,ps] = mapminmax(dataset',0,1);
% %dataset_scale = dataset_scale'; 
% X_s = dataset_scale(:,1:ns); 
% Xt = dataset_scale(:,ns+1:end);

Ys=zeros(ns,nc);
for i=1:ns
    Ys(i,Y_src(i))=1;
end
Xy = X_src*Ys;

%W=LS_W(X_src,Y_src,lamda);
W = (X_src*X_src'+lambda*eye(d))\Xy;
Y_pre = X_tar'*W;
Ypre = zeros(nt,1);
for i = 1:nt
    [~,Ypre(i)] = find( Y_pre(i,:) == max(Y_pre(i,:)) );
end
acc = length(find(Ypre==Y_tar))/length(Y_tar);
fprintf('acc: %0.2f\n', acc);

% for t=1:length(lambdalib)
%     lambda=lambdalib(t);
%     %W=LS_W(X_src,Y_src,lamda);
%     W=(X_src*X_src'+lambda*eye(d))\Xy;
%     Y_pre=X_tar'*W;
%     Ypre=zeros(nt,1);
%     for i=1:nt
%         [~,Ypre(i)] = find( Y_pre(i,:) == max(Y_pre(i,:)) );
%     end
%     acc(t)=length(find(Ypre'==Y_tar))/length(Y_tar);
%     if t==1
%         acc_best=acc(t);
%     elseif acc(t)>acc_best
%         acc_best=acc(t);
%     end
% end
%  fprintf('ACC=%0.4f\n',acc_best);
