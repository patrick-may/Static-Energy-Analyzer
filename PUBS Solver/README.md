## PUBS ##


The executable does not display usage information so here is a quick
introduction:

** pubs_static -file XX.ces : computes upper bounds assuming that the
   first equation in the file is the entry

** pubs_static -file XX.ces -entry 'a(N):[N>=10]' : computes upper
   bounds assuming the entry a(N) with the initial constraints N>=10. The
   initial constraints can be any list of constraints, eg., [N>=10,B>=C,...]

** by default PUBS use the node-count scheme, you can enable the level-count scheme,
   which is used for divide-and-conquer examples, using the option

      -computebound ubnormal_withlevelcountenabled

   for example:
   
     ./pubs_static -file XX.ces -computebound ubnormal_withlevelcountenabled
     ./pubs_static -file XX.ces -entry 'a(N):[N>=10]' -computebound ubnormal_withlevelcountenabled

   you can also use 'ubseries' or 'lbseries' instead of 'ubnormal_withlevelcountenabled' to
   enable the schemes of the TOCL 2013 paper, but those require maxima to be installed


** The default output is just plain text, with many intermediate
   information that pubs computes (e.g., invariants, ranking functions
   for loops, etc.). It can also generate the output in XML using the
   option "-output xml".

** use the option "-show_asym yes" to get the bounds in asymptotic
   form as well

** You can file many ".ces" file examples in

   http://costa.ls.fi.upm.es/~costa/pubs/examples.php

** The output includes an upper bound for each equation in the input
   file, but some might disappear due to an unfolding step that we apply
   to simplify them into direct recursion form. You will always have an
   upper bound for an auxiliary equation (added automatically) called
   '$pubs_aux_entry$', which corresponds to the entry w.r.t which the
   equations were analyzed (we use this because unfolding might eliminate
   the entry equation).
