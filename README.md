# agoraconfiguration

Goal is to apply the CMB lensing standard quadratic estimator on Agora simulations.

Using Niall's codes (found on ACTCollaboration github).

* First step, is to prepare maps
`python prepare_maps.py -c agora_all_wnoise-wdr6dn.yml --output_dir /pscratch/sd/o/omard/FGSIMS_OUT/agora`

This outputs useful maps in `/pscratch/sd/o/omard/FGSIMS_OUT/agora`.

Mainly, my doubts:
```yaml
noise_from_ivar:
    - /global/cfs/cdirs/act/data/sigurdkn/actpol/maps/dr6v3_20211031/release_bestpass/cmb_daynight_tot_f090_coadd_ivar.fits
    - /global/cfs/cdirs/act/data/sigurdkn/actpol/maps/dr6v3_20211031/release_bestpass/cmb_daynight_tot_f150_coadd_ivar.fits
  survey_mask_hpix: /pscratch/sd/o/omard/FGSIMS_USEFUL/dr6v2_default_union_mask_wnemo_nside4096.fits
  beam_from_file:
    - /global/cfs/projectdirs/act/data/act_dr5/s08s18_coadd/auxilliary/beams/act_planck_dr5.01_s08s18_f090_daynight_beam.txt
    - /global/cfs/projectdirs/act/data/act_dr5/s08s18_coadd/auxilliary/beams/act_planck_dr5.01_s08s18_f150_daynight_beam.txt
  save_survey_mask: True
```

The source of the Agora sims are maps prepared by ACT members (`/global/cfs/projectdirs/act/data/agora_sims/outputs`). These are full-sky.


* Then, run bash `nemo\_ps.sh`. This step includes point source finding, and point source modelling.

For point source finding,
```yaml
thresholdSigma: 4.0
minObjPix: 1
findCenterOfMass: True
useInterpolator: True
rejectBorder: 0
objIdent: 'PS'
longNames: False
catalogCuts: ['SNR > 4.0']
measureShapes: True
```


```yaml
tileDefinitions: {mask: '/pscratch/sd/o/omard/FGSIMS_OUT/agora/prep_map/survey_mask.fits',
                  targetTileWidthDeg: 10.0,
                  targetTileHeightDeg: 5.0}
```

The survey mask above is created with the `prepare_maps.py` and it is full sky (just ones).

Which is the correct `surveyMask` key to use for point source finding mode?

* Step for tSZ clusters and model template.

* Finally, you need to subtract at the map level the models the previous models.

* Use the results of the previous sections to create foregrounds only maps without noise
`python prepare_maps.py`

* Finally, apply lensing reconstruction using Niall's code

* To normalize, I will use Gerrit's MC norm corrections from 400 simulations (this is a different pipeline, but it should be fine I guess)