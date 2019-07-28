
ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages = 'E:\Data Thesis processing\lentigo simplex\segmented\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\jpg\renamed\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:

MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.png'; %image format
if (ComputeAll)
    show       = 0; %Do not show results
    MustSave   = 1; %Save results on file
else
    show       = 1; %Show results
    MustSave   = 0; %Do not save results on file
end
%Creates the output directory, if necessary
if (MustSave && not(exist(DirResults,'dir')))
    mkdir(DirResults);
end

ImgName = strcat(DirImages,Fmt);
ImgList = dir(ImgName);
NumberOfImages = size(ImgList,1)
if (ComputeAll)
    ninit = 1; nend = NumberOfImages; 
else
    ninit = NumImm; nend = NumImm; 
end
datA=zeros(27,22);
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I=imread(ImgName,'png');
    I=rgb2gray(I);
    GLCM2 = graycomatrix(I,'Offset',[0 2;-2 2;-2 0;-2 2],'Symmetric',true); 
    outt = GLCM_Features1(GLCM2,0);
    
    acor=outt.autoc;
    av_acor=sum(acor(:))/numel(acor);
    datA(number,1)=av_acor;
    
    % = zeros(1,size_glcm_3); % Autocorrelation
    contra=outt.contr;
    av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast
    datA(number,2)=av_contra;
    
    cor=outt.corrm; 
    av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation: matlab
    datA(number,3)=av_cor;
     
    corrh=outt.corrp;
    av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation
    datA(number,4)=av_corrh;
    
    clp=outt.cprom; 
    av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence
    datA(number,5)=av_clp;
    
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade
    av_clsh=sum(clsh(:))/numel(clsh);
    datA(number,6)=av_clsh;
    
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity
    av_diss=sum(diss(:))/numel(diss);
    datA(number,7)=av_diss;
    
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy
    av_eng=sum(eng(:))/numel(eng);
    datA(number,8)=av_eng;
    
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy
    av_entro=sum(entro(:))/numel(entro);
    datA(number,9)=av_entro;
    
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity: matlab
    av_homm=sum(homm(:))/numel(homm);
    datA(number,10)=av_homm;
    
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    av_hompp=sum(hompp(:))/numel(hompp);
    datA(number,11)=av_hompp;
    
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    av_maxpr=sum(maxpr(:))/numel(maxpr);
    datA(number,12)=av_maxpr;
    
    vari=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures: Variance
    av_var=sum(vari(:))/numel(vari);
    datA(number,13)=av_var;
    
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average
    av_sumav=sum(sumav(:))/numel(sumav);
    datA(number,14)=av_sumav;
    
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    av_sumvar=sum(sumvar(:))/numel(sumvar);
    datA(number,15)=av_sumvar;
    
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy
    av_sumentro=sum(sumentro(:))/numel(sumentro);
    datA(number,16)=av_sumentro;
    
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    av_diffvar=sum(diffvar(:))/numel(diffvar);
    datA(number,17)=av_diffvar;
    
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy
    av_diffentro=sum(diffentro(:))/numel(diffentro);
    datA(number,18)=av_diffentro;
    
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1
    av_infcor1=sum(infcor1(:))/numel(infcor1);
    datA(number,19)=av_infcor1;
    
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2
    av_infcor2=sum(infcor2(:))/numel(infcor2);
    datA(number,20)=av_infcor2;
    
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN)
    av_invdnor=sum(invdnor(:))/numel(invdnor);
    datA(number,21)=av_invdnor;
    
    invdmnor=outt.idmnc;
    av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datA(number,22)=av_invdmnor;
 
   
end
toc


ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages = 'E:\Data Thesis processing\solar lentigo\segmented\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\jpg\renamed\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:

MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.png'; %image format
if (ComputeAll)
    show       = 0; %Do not show results
    MustSave   = 1; %Save results on file
else
    show       = 1; %Show results
    MustSave   = 0; %Do not save results on file
end
%Creates the output directory, if necessary
if (MustSave && not(exist(DirResults,'dir')))
    mkdir(DirResults);
end

ImgName = strcat(DirImages,Fmt);
ImgList = dir(ImgName);
NumberOfImages = size(ImgList,1)
if (ComputeAll)
    ninit = 1; nend = NumberOfImages; 
else
    ninit = NumImm; nend = NumImm; 
end
datB=zeros(56,22);
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I=imread(ImgName,'png');
    I=rgb2gray(I);
    GLCM2 = graycomatrix(I,'Offset',[0 2;-2 2;-2 0;-2 2],'Symmetric',true); 
    outt = GLCM_Features1(GLCM2,0);
    
    acor=outt.autoc;
    av_acor=sum(acor(:))/numel(acor);
    datB(number,1)=av_acor;
    
    % = zeros(1,size_glcm_3); % Autocorrelation
    contra=outt.contr;
    av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast
    datB(number,2)=av_contra;
    
    cor=outt.corrm; 
    av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation: matlab
    datB(number,3)=av_cor;
     
    corrh=outt.corrp;
    av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation
    datB(number,4)=av_corrh;
    
    clp=outt.cprom; 
    av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence
    datB(number,5)=av_clp;
    
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade
    av_clsh=sum(clsh(:))/numel(clsh);
    datB(number,6)=av_clsh;
    
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity:
    av_diss=sum(diss(:))/numel(diss);
    datB(number,7)=av_diss;
    
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy: matlab 
    av_eng=sum(eng(:))/numel(eng);
    datB(number,8)=av_eng;
    
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy:
    av_entro=sum(entro(:))/numel(entro);
    datB(number,9)=av_entro;
    
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity: matlab
    av_homm=sum(homm(:))/numel(homm);
    datB(number,10)=av_homm;
    
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    av_hompp=sum(hompp(:))/numel(hompp);
    datB(number,11)=av_hompp;
    
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    av_maxpr=sum(maxpr(:))/numel(maxpr);
    datB(number,12)=av_maxpr;
    
    vari=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures: Variance
    av_var=sum(vari(:))/numel(vari);
    datB(number,13)=av_var;
    
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average
    av_sumav=sum(sumav(:))/numel(sumav);
    datB(number,14)=av_sumav;
    
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    av_sumvar=sum(sumvar(:))/numel(sumvar);
    datB(number,15)=av_sumvar;
    
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy 
    av_sumentro=sum(sumentro(:))/numel(sumentro);
    datB(number,16)=av_sumentro;
    
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    av_diffvar=sum(diffvar(:))/numel(diffvar);
    datB(number,17)=av_diffvar;
    
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy
    av_diffentro=sum(diffentro(:))/numel(diffentro);
    datB(number,18)=av_diffentro;
    
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1
    av_infcor1=sum(infcor1(:))/numel(infcor1);
    datB(number,19)=av_infcor1;
    
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2
    av_infcor2=sum(infcor2(:))/numel(infcor2);
    datB(number,20)=av_infcor2;
    
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN)
    av_invdnor=sum(invdnor(:))/numel(invdnor);
    datB(number,21)=av_invdnor;
    
    invdmnor=outt.idmnc;
    av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datB(number,22)=av_invdmnor;
   
end
toc
%%
dataall=zeros(108,22);

class=zeros(84,1);
class1=zeros(27,1);
class1(:,:)=1;
[asd class]=SMOTE(datA,class1);

dataall(1:54,:)=asd(: ,:);
dataall(55:108,:)=datB(1:54,:);

classall=zeros(81,1);
classall(1:27,1)=1;
classall(28:81,1)=2;

aamuall = mean(dataall); 
aamuA=mean(datA);
aamuB=mean(datB);
aavarall=var(dataall);
aavarA=var(datA);
aavarB=var(datB);
fsr=zeros(22,1);
for gg=1:22
    up=((27*((aamuA(1,gg)-aamuall(1,gg))^2))+(56*(aamuB(1,gg)-aamuall(1,gg))^2));
    down=(27*aavarA(1,gg)+56*aavarB(1,gg));
    fsr(gg,1)=up/down;
end

data_selected=zeros(81,14);
data_selected(:,1:5)=dataall(:,1:5);
data_selected(:,6:7)=dataall(:,8:9);
data_selected(:,8:13)=dataall(:,12:17);
data_selected(:,14)=dataall(:,20);
%disk=abs(aavarA-aavarB);

datainput=dataall';
classtarget=zeros(1,108);
classtarget(1,1:54)=1;

targettt=tagett;
tagett=zeros(2,22);
tagett(1,:)=aamuA(:,:);
tagett(2,:)=aamuB(:,:);
[Train, Test] = crossvalind('HoldOut', classall, 0.3);
datatrain_f = dataall(Train,:);
datatest_f=dataall(Test,:);
classtrain=classall(Train,:);
classtest=classall(Test,:);

datann=dataall';






min=0;
SVMModels = fitcsvm(datatrain_f,classtrain,'KernelFunction','rbf','KernelScale','auto', 'Standardize', true,'BoxConstraint',1,'OutlierFraction',0.20);
%SVMModels = fitcsvm(datatrain,classtrain,'KernelFunction','rbf','KernelScale',1,'BoxConstraint',1);
%knn=fitcknn(datatrain_f, classtrain,'NumNeighbors',3);
%SVMModels = fitcsvm(dattrain,classtrain);

[label,score] = predict(SVMModels,datatest_f);
[rr cc]=size(label);
count=0;
for i=1:rr
    if(label(i,1)==classtest(i,1))
        count=count+1;
    end
end
 accu=count/numel(label)
 EVAL = eevaluate(classtest,label);