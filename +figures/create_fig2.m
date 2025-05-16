save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/fig2';

run_analysis  = 1;
save_analysis = 1;
% load area information such as session ID's
load.load_area_info()
% load session information
mData = load.load_area_sData(data,1);

if run_analysis
     mData       = analysis.create_rmaps(mData,data,1,save_analysis);
     mData       = classification.classification_main(mData,data,1,save_analysis);   
     mData       = analysis.field_info(mData,data,1,save_analysis);   
     mData = decoding.decoding_time_sessions(mData,data,run_analysis,save_analysis); 
     mData = decoding.decoding_trials_sessions(mData,data,run_analysis,save_analysis); 
 else
     mData = load.load_rmaps(mData,data,1);
     mData = load.load_classification(mData,data,1);
     mData = load.load_all_field_info(mData,data,1);
     mData       = decoding.decode_time_sessions(mData,data,run_analysis,save_analysis); 
     mData       = decoding.decode_trials_sessions(mData,data,run_analysis,save_analysis); 
end
 
figures.fig2.fig2_a;
figures.fig2.fig2_b;
figures.fig2.fig2_c_d;

figures.fig2.fig2_d;
figures.fig2.fig2_e;
figures.fig2.fig2_e_f;



