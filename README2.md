# DWI_reg
A project to achieve the straightforward DWI registrations.

After preliminary review and my verification, straightforward diffusion gradients reorientation was improper without modeling the signla profile. Fortunately, this part of work is not the innovation point in my Ph.D. thesis, I can achieve by following the Yap et al.[^1] method.  

### The substantial steps
In this paper, one model and one solver are outperformance than others, the model is Tensor DBFs (diffusion basis function), the formular is as follows:
$$ S\left( {{g_i}} \right) = \sum\limits_{j = 0}^N {{\omega _j}{f_j}\left( {{g_i}|{\lambda _1},{\lambda _2}} \right)} $$

[^1]: Yap, P.T., Shen, D., 2012. Spatial transformation of DWI data using non-negative sparse representation. IEEE Trans. Med. Imaging 31, 2035–2049. doi:10.1109/TMI.2012.2204766
 
