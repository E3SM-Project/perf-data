import math

def list_chrys_good_nodecounts(ne, gap=0.2):
    ceil = math.ceil
    ncol_gll  = 6*ne*ne*9 + 2
    ncol_pg   = 6*ne*ne*4
    ncol_elem = 6*ne*ne
    max_nodes = ceil(ncol_gll/64.0)
    for nc in range(5,max_nodes+1):
        ng     = ncol_gll /float(64*nc)
        ngm1   = ncol_gll /float(64*(nc-1))
        np     = ncol_pg  /float(64*nc)
        npm1   = ncol_pg  /float(64*(nc-1))
        nel    = ncol_elem/float(64*nc)
        nelm1  = ncol_elem/float(64*(nc-1))
        good_g = ceil(ng)  != ceil(ngm1) and ceil(ng) - ng < gap
        good_p = ceil(np)  != ceil(npm1) and ceil(np) - np < gap
        good_e = ceil(nel) != ceil(nelm1)
        if (good_g or good_p or good_e):
            print('{:3d} {:s} {:s} {:s}'.format(
                nc,
                "{:4d}".format(ceil(ng )) if good_g else "    ",
                "{:4d}".format(ceil(np )) if good_p else "    ",
                "{:4d}".format(ceil(nel)) if good_e else "    ",))

list_chrys_good_nodecounts(30)
