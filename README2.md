# DWI_reg
A project to achieve the straightforward DWI registrations.

After preliminary review and my verification, straightforward diffusion gradients reorientation was improper without modeling the signla profile. Fortunately, this part of work is not the innovation point in my Ph.D. thesis, I can achieve by following the Yap et al.[^1] method.  

### The substantial steps
1. In this paper, one model and one solver are outperformance than others, the model is Tensor DBFs (diffusion basis function), the formular is as follows:
$$ S\left( {{g_i}} \right) = \sum\limits_{j = 0}^N {{\omega _j}{f_j}\left( {{g_i}|{\lambda _1},{\lambda _2}} \right)} $$

and $ {{f_j}\left( {{g_i}|{\lambda _1},{\lambda _2}} \right)}$ is defined as:
$${f_j}\left( {{g_i}|{\lambda _1},{\lambda _2}} \right) = \exp \left( { - b{g_i}^T{D_j}{g_i}} \right)$$.

With these two formulation, we can rewrite the DWI signal profile as:
$$S=Fw$$.


1. $S$ and $F$ is known, $w$ should be calculated with a reasonable solver, which in the paper is a non-negative L1-regularized least-squared problem:
$$(Sparse)\;\;\;\min \left\{ {\left\| {S - Fw} \right\|_2^2 + \beta {{\left\| w \right\|}_1}} \right\}\;s.t.\;w \ge 0$$, where $\beta$ is a tuning parameter.

The following table shows the steps to solve this problem.
   | step | operate
   |---|---|
   | 1 | Initialize $w=0$ and active set = {}. |
   | 2 | From 0 weights of $w$, select $i = \arg \;\mathop {\min }\limits_i \frac{{\partial \left\| {S - Fw} \right\|_2^2}}{{\partial {w_i}}}$
   | 3 | if $\frac{{\partial \left\| {S - Fw} \right\|_2^2}}{{\partial {w_i}}} < -\beta$ then
   | 4 | add $i$ to the active set
   | 5 | set $w_i=0^+$
   | 6 | else
   | 7 | stop algorithm and return $w$
   | 8 | end if
   | 9 | Let $\widehat F$ be a submatrix of $F$ that contains only the column corresponding to the active set.
   | 10 | Let $\widehat w$ be the subvector of w corresponding to the active set
   | 11 | Compute the solution to the unconstrained quadratic programming problem $\left\| {S - \widehat F{{\widehat w}_{new}}} \right\|_2^2 + \beta {c^T}{\widehat w_{new}}$, where $c={c_k}, c_k = 1, \forall k$, the analytical solution is ${\widehat w_{new}} = {\left( {{{\widehat F}^T}\widehat F} \right)^{ - 1}}\left( {{{\widehat F}^T}S - \frac{\beta }{2}c} \right)$
   | 12 | if there is any weight sign change between $\widehat w$ to $\widehat w_{new}$, then
   | 13 | Detemine the points where any weight changes sign and update $\widehat w$ to the point that will result in a set of nonnegative coefficients
   | 14 | Remove zero weights of $\widehat w$ from the active set
   | 15 | Goto step 9
   | 16 | else
   | 17 | Goto step 2
   | 18 | end if|

3. There are some key parameters to initialize.
 
   - The number of orientations to construct $F$, in this paper, they used 321 directions.
   - The eigenvalues of $D_j$, they set them seperately as $\lambda_1=1.5\times10^{-3}mm^2/s $ and $\lambda_2 = \lambda_3=3\times10^{-4}mm^2/s$
   - $b=2000s/mm^2$

[^1]: Yap, P.T., Shen, D., 2012. Spatial transformation of DWI data using non-negative sparse representation. IEEE Trans. Med. Imaging 31, 2035–2049. doi:10.1109/TMI.2012.2204766
 
