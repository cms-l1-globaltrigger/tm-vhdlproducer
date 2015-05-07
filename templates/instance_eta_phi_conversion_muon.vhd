muon_data_bx_{Bx}_l: for i in 0 to NR_MUON_OBJECTS-1 generate
    muon_eta_bx_{Bx}(i)(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0) <= muon_bx_{Bx}(i)(d_s_i_muon.eta_high downto d_s_i_muon.eta_low);
    muon_eta_common_bx_{Bx}(i)(d_s_i_muon.eta_high-d_s_i_muon.eta_low+2 downto 0) <= 
        muon_eta_bx_{Bx}(i)(d_s_i_muon.eta_high-d_s_i_muon.eta_low) & muon_eta_bx_{Bx}(i)(d_s_i_muon.eta_high-d_s_i_muon.eta_low downto 0) & '1';
    muon_phi_bx_{Bx}(i)(d_s_i_muon.phi_high-d_s_i_muon.phi_low downto 0) <= muon_bx_{Bx}(i)(d_s_i_muon.phi_high downto d_s_i_muon.phi_low);
    muon_phi_common_bx_{Bx}(i)(d_s_i_muon.phi_high-d_s_i_muon.phi_low+1 downto 0) <= muon_bx_{Bx}(i)(d_s_i_muon.phi_high downto d_s_i_muon.phi_low) & '1';
end generate;
