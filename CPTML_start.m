function acc_final = CPTML_start(pid,sid1,sid2,options)
fprintf('===== %d ===== \n', pid);
    data_path = strcat('D:/doctor/peng/metric learning/code/LPJT-emotion-preprocess/data/subject', num2str(pid), '/');
    load(strcat(data_path, 'fea_session',sid1,'_subject',num2str(pid),'.mat'));
    Xs = fea'; % n-by-d
    load(strcat(data_path, 'fea_session',sid2,'_subject',num2str(pid),'.mat'));
    Xt = fea';
    load(strcat(data_path, 'gnd_session',sid1,'.mat'));
    Ys = gnd;
    load(strcat(data_path, 'gnd_session',sid2,'.mat'));
    Yt = gnd;
    clear fea gnd
    
    Xs_raw = Xs';
    Xt_raw = Xt';
    
%     Xs = Xs ./ repmat(sum(Xs,2),1,size(Xs,2));  % d-by-d
%     Xs = zscore(Xs);
%     Xs = normr(Xs);
%     Xs = Xs';
%     
%     Xt = Xt ./ repmat(sum(Xt,2),1,size(Xt,2)); % d-by-d
%     Xt = zscore(Xt);
%     Xt = normr(Xt);
%     Xt = Xt';
    
    Xs=mapminmax(Xs,-1,1);
    Xt=mapminmax(Xt,-1,1);
    Xs=Xs-repmat(mean(Xs,2),[1,size(Xs,2)]);
    Xt=Xt-repmat(mean(Xt,2),[1,size(Xt,2)]);
    Xs = Xs';
    Xt = Xt';
    
    DataArr.Xs = Xs;
    DataArr.Ys = Ys;
    DataArr.Xt = Xt;
    DataArr.Yt = Yt;
    
    %% train
    [acc]=CPTML(DataArr,options);
%     plot(accVec);
    acc_final = acc;

    %% save data: A, B, Zs, Zt, Ys, Yt
%     folder_now = pwd;
%     save(strcat(folder_now, '/result_visual/result_s',sid1,'s',sid2,'_subject',num2str(pid),'.mat'), 'acc', 'options', 'A', 'B', 'Xs_raw', 'Xt_raw', 'Xs', 'Xt', 'Zs', 'Zt', 'Ys', 'Yt', 'Ft', 'Ps', 'Pt', 'YtP');
end
