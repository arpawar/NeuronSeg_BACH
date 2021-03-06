function RHS = compute_Integ_Domain_fidelity(Jm,Bseg,Bsegx,Bsegy,Bsegz,RHSf,PHI1,w1,w2,w3,H)
%% This function computes the energy functional for segmentation in step 1

%% INPUT:
%Jm: matrix of non-zero splines
%Bseg: matrix computing the segmentationt term
%Bsegx: Derivative_x of phi
%Bsegy: Derivative_y of phi
%Bsegz: Derivative_z of phi
%RHSf: Right hand side of update of control points in step 1
%PHI1: Basis function matrix
%w1, w2, w3: weights of Gaussian integration
%H : size of each B-spline control grid element

%OUTPUT:
%RHS: Right hand side matrix for updating control points

ac_ct = size(Jm,1);
bf_ct = size(RHSf,1);
xlen = 4;

parfor i = 1:ac_ct
    
    RHSf1 = zeros(bf_ct,4);
    
    SB = Jm(i).nzsplines;
    supp_phi = PHI1(i).mat;
    supp_size = size(SB,1);
    
    hu = H(i,1);
    hv = H(i,2);
    hw = H(i,3);
    
    term7 = Bseg(1+(i-1)*xlen:i*xlen,1:xlen,1:xlen);
    term8 = Bsegx(1+(i-1)*xlen:i*xlen,1:xlen,1:xlen);
    term9 = Bsegy(1+(i-1)*xlen:i*xlen,1:xlen,1:xlen);
    term10 = Bsegz(1+(i-1)*xlen:i*xlen,1:xlen,1:xlen);
    
    val1f = zeros(supp_size,1);
    val2f = zeros(supp_size,1);
    val3f = zeros(supp_size,1);
    
    valm1f = zeros(supp_size,xlen,xlen,xlen);
    valm2f = zeros(supp_size,xlen,xlen,xlen);
    valm3f = zeros(supp_size,xlen,xlen,xlen);
    
    for gg1 = 1:xlen
        for gg2 = 1:xlen
            for gg3 = 1:xlen
                phi_i  = supp_phi(:,gg1,gg2,gg3);
                
                valm1f(:,gg1,gg2,gg3) = term7(gg1,gg2,gg3)*term8(gg1,gg2,gg3)*phi_i;
                valm2f(:,gg1,gg2,gg3) = term7(gg1,gg2,gg3)*term9(gg1,gg2,gg3)*phi_i;
                valm3f(:,gg1,gg2,gg3) = term7(gg1,gg2,gg3)*term10(gg1,gg2,gg3)*phi_i;
                
                val1f(:,1) = val1f(:,1) + w1(gg1,1).*w2(gg2,1).*w3(gg3,1).*valm1f(:,gg1,gg2,gg3).*hu.*hv.*hw;
                val2f(:,1) = val2f(:,1) + w1(gg1,1).*w2(gg2,1).*w3(gg3,1).*valm2f(:,gg1,gg2,gg3).*hu.*hv.*hw;
                val3f(:,1) = val3f(:,1) + w1(gg1,1).*w2(gg2,1).*w3(gg3,1).*valm3f(:,gg1,gg2,gg3).*hu.*hv.*hw;
                
            end
        end
    end
    
    RHSf1(SB,1) = val1f;
    RHSf1(SB,2) = val2f;
    RHSf1(SB,3) = val3f;
    
    RHSf = RHSf  + RHSf1;
    
end

RHS = RHSf;
end

