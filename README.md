# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud
GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

# Github Action for developers to delete Okteto Pipelines from a GitHub Actions workflow

You can use this action to delete an [Okteto Pipeline](https://okteto.com/blog/cloud-based-development-environments/) based on Github events. 

You can use this action to cleanup your CI/CD workflow in [Okteto Cloud](https://cloud.okteto.com).

[This document](https://okteto.com/docs/tutorials/getting-started-with-pipelines/index.html) has more information on this workflow.

## Inputs

### `name`

The name of the pipeline.

### `namespace`

The Okteto namespace to use. If not specified it will use the namespace specified by the `namespace` action.

# Example usage

This example runs the login action, activates a namespace, and triggers the Okteto pipeline and deletes it

```yaml
# File: .github/workflows/workflow.yml
on: 
  pull_request: 
    types:
      - closed

name: example

jobs:
  devflow:
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      uses: actions/checkout@master    

    - name: Login
      uses: okteto/login@latest
      with:
        token: ${{ secrets.OKTETO_TOKEN }}

    - name: "Activate Namespace"
      uses: okteto/namespace@latest
      with:
        name: cindylopez
    
    - name: "Trigger the pipeline"
      uses: okteto/pipeline@latest
      with:
        name: pr-${{ github.event.number }}
    
    - name: "Destroy the pipeline"
      uses: okteto/destroy-pipeline@latest
      with:
        name: pr-${{ github.event.number }}
```


## Advanced usage

 ### Custom Certification Authorities or Self-signed certificates

 You can specify a custom certificate authority or a self-signed certificate by setting the `OKTETO_CA_CERT` environment variable. When this variable is set, the action will install the certificate in the container, and then execute the action. 

 Use this option if you're using a private Certificate Authority or a self-signed certificate in your [Okteto Enterprise](http://okteto.com/enterprise) instance.  We recommend that you store the certificate as an [encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets), and that you define the environment variable for the entire job, instead of doing it on every step.


 ```yaml
 # File: .github/workflows/workflow.yml
 on: [push]

 name: example

 jobs:
   devflow:
     runs-on: ubuntu-latest
     env:
       OKTETO_CA_CERT: ${{ secrets.OKTETO_CA_CERT }}
     steps:
     - name: checkout
       uses: actions/checkout@master    

     - name: Login
       uses: okteto/login@latest
       with:
         token: ${{ secrets.OKTETO_TOKEN }}

     - name: "Activate Namespace"
       uses: okteto/namespace@latest
       with:
         name: cindylopez
      
      - name: "Trigger the pipeline"
        uses: okteto/pipeline@latest
        with:
          name: pr-${{ github.event.number }}
      
      - name: "Destroy the pipeline"
        uses: okteto/destroy-pipeline@latest
        with:
          name: pr-${{ github.event.number }}
```