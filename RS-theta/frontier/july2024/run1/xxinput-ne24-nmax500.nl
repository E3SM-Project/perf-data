&ctl_nl
NThreads=1
partmethod    = 4
topology      = "cube"
test_case     = "jw_baroclinic"
u_perturb = 1
rotate_grid = 0

ne = 24
nmax         = 500

statefreq=999999
disable_diagnostics = .true.
restartfreq   = 43200
restartfile   = "./R0001"
runtype       = 0
mesh_file='/dev/null'
integration   = "explicit"

qsize=10
cubed_sphere_map = 2
dt_remap_factor = 2
dt_tracer_factor = 6
hv_ref_profiles = 6
hypervis_order = 2
hypervis_scaling = 3.0
hypervis_subcycle = 1
hypervis_subcycle_tom = 1
hypervis_subcycle_q = 6
nu = 3.4e-08
nu_top = 10000.0
pgrad_correction = 1
se_ftype = 0
limiter_option = 9
tstep = 1
theta_advect_form = 1
theta_hydrostatic_mode = .false.
tstep_type = 9
vert_remap_q_alg = 10
transport_alg = 12
vtheta_thresh = 180
internal_diagnostics_level = 0
/

&vert_nl
vfile_mid = './sabm-128.ascii'
vfile_int = './sabi-128.ascii'
/
&prof_inparm
profile_outpe_num = 100
profile_single_file             = .true.
/

&analysis_nl
! disabled
 output_timeunits=1,1
 output_frequency=-1,-1
 output_start_time=0,0
 output_end_time=30000,30000
 output_varnames1='ps','zeta','T','geo'
 output_varnames2='Q','Q2','Q3','Q4','Q5'
! output_prefix='xx-ne20-'
 io_stride=8
 output_type = 'netcdf'
/



