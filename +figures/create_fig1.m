% close all
% clear all
save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig1';
% 
% % run all analysis from scratch or load previous analysis
run_analysis  = 1;
save_analysis = 1;
% % % load area information such as session ID's
load.load_area_info()
% % % load session information
load.load_area_sData();%(data);

if run_analysis
     mData = analysis.create_rmaps(mData,data,1,save_analysis);
     mData = classification.classification_main(mData,data,1:5,save_analysis); 

else
    mData = load.load_rmaps(mData,data,1);
    mData = load.load_classification(mData,data,1);
end
    

figures.fig1.fig1_c;
figures.fig1.fig1_d;
figures.fig1.fig1_e;
figures.fig1.fig1_g_h;
figures.fig1.fig_1h;
figures.fig1.fig_1i;
figures.fig1.fig1_k;