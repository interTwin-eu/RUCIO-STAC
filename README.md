# RUCIO and STAC Metadata Integration
This document summarizes the process involved in the generation of STAC Collections from datasets provided in the [InterTwin DataLake](https://confluence.egi.eu/display/interTwin/Data+Samples+from+the+Use+Cases) accessible using [rucio](https://confluence.egi.eu/display/interTwin/Tutorial+on+how+to+interact+with+Rucio+and+the+data+lake). The central idea is to provide a STAC JSON that could be used in downstream analytic pipelines for the different thematic use cases in the InterTwin project. This STAC JSON is expected to contain links to Cloud-Optimized-GeoTIFFS provided on a publicly accessible S3 storage through the STAC as well as an alternative link to the original datasets available in the InterTwin DataLake. The steps involved in generating these STAC JSON and interacting with the DataLake are outline below. 

### Main steps
<details>
<summary>Expand</summary>

- Rucio Installation for a Debian-based OS, 
- Pre-requisites for accessing datasets in the data lake,
- Downloading specified datasets, 
- Generating STAC Collections using Raster2STAC, 
- Extending STAC JSON to contain link to InterTwin Datalake, 
- Load datasets with downstream packages

</details>


### Rucio Installation for a Debian-based OS
<details>
<summary>Expand</summary>

A full documentation on how to interact with the data lake using rucio and detailed introduction to important rucio terminologies are provided [here](https://confluence.egi.eu/display/interTwin/Tutorial+on+how+to+interact+with+Rucio+and+the+data+lake). Nonewithstanding, we highlight some of the specific requirements needed for using rucio on a Debian-based OS (such as Ubuntu, which currently being at EURAC Research at the time of writing this document.)

In your development environment, [install rucio](https://rucio.cern.ch/documentation/user/setting_up_the_rucio_client/) with pip `pip install rucio-clients`. This provides you with both the Rucio Client CLI and the Rucio Client Python API, however since rucio uses Gfal, which is not compatible with debian, to download and upload data you would need to run your operations in a containerized environment. The recommended docker image for interacting with the InterTwin datalake is provided [here](https://hub.docker.com/r/dvrbanec/rucio-client):: `dvrbanec/rucio-client:latest`, which requires you to mount the configuration file to run effectively.

```bash
docker run \
  -v /tmp/rucio.cfg:/opt/rucio/etc/rucio.cfg \
  --name=rucio-client \
  -it -d rucio/rucio-clients
```

The details for setting up the configuration is provided in the next section. 

</details>


### Pre-requisites for accessing datasets in the data lake
<details>
<summary>Expand</summary>

In order to access the data in the InterTwin datalake, the following pre-requisites should be met.

1. Register and request access to the interTwin dev (dev.intertwin.eu) with your EGI Check-in credentials [here](https://aai-demo.egi.eu/registry).

    Once signed in with your EGI Credentials, go to People --> Enroll. Search for "Join dev.intertwin.eu VO" and click on "Begin" and request access to the VO from there. Please note that the access approval depends on the availability of the administrator. See this [documentation](https://confluence.egi.eu/display/interTwin/interTwin+AAI) for more details.

2. Set up your rucio configuration in `rucio.cfg`. Here is a sample configuration we used: 
    ```bash
    [client]
    rucio_host = https://rucio-intertwin-testbed.desy.de
    auth_host = https://rucio-intertwin-testbed-auth.desy.de
    ca_certs = /etc/ssl/certs/ca-bundle.crt
    account = <YOUR_ACCOUNT_NAME> # your EGI check-in account name
    auth_type = oidc
    auth_token_file_path = /tmp/rucio_oauth.token
    oidc_scope = openid profile offline_access eduperson_entitlement

    [download]
    transfer_timeout = 3600000
    preferred_impl = xrootd, rclone 
    ```

3. Install the necessary certifications to validate rucio access to the intertwin DataLake, see the compatible files in the provided `Dockerfile`

4. Run your container and start using rucio commands, remember to also mount the path you would like your datasets to be stored in
    ```bash
    docker run \
    -v /tmp/rucio.cfg:/opt/rucio/etc/rucio.cfg \
    -v /data_path:~/data_path \
    --name=rucio-client \
    -it -d dvrbanec/rucio-client:latest
    ```

    Then use rucio commands: 
    ```
    docker exec -it rucio-client /bin/bash
    $ rucio ping
    ```

5. Authenticate your rucio

    Run `rucio whoami` and Rucio will give you a link to authenticate yourself. Follow the instructions on the link and at the end you will get a code that you should copy back to Rucio in the terminal. Once you've copied the code back to Rucio, you'll be authenticated to Rucio.


</details>


### Downloading specified datasets
<details>
<summary>Expand</summary>

To download a specific dataset from the InterTwin data lake, you just need to get to the Data IDentifier (DID) and run `rucio get DID` 


To perform other functions with rucio such as upload and creating datasets, see the full documentation [here](https://confluence.egi.eu/display/interTwin/Tutorial+on+how+to+interact+with+Rucio+and+the+data+lake) and [here](https://rucio.github.io/documentation/user/using_the_client)
</details>


### Generating STAC collections using Raster2STAC
<details>
<summary>Expand</summary>

See sample notebook `RUCIO_STAC.ipynb` for details on generating STAC collection using [Raster2STAC](https://pypi.org/project/raster2stac/)

</details>


### Extending STAC JSON to contain link to the InterTwin Datalake
<details>
<summary>Expand</summary>

Coming soon!

</details>


### Load dataset with downstream packages
<details>
<summary>Expand</summary>

With tools like `odc.stac` or `stackstac`, it should be possible to load the datasets from the STAC JSON into an xArray object. See [stackstac](https://stackstac.readthedocs.io/en/latest/) and [odc.stac](https://odc-stac.readthedocs.io/en/latest/)

</details>
