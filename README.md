End-to-End GitOps Pipeline

In this walkthrough, we will explore the architecture, set up a local development environment, execute the pipeline, and discuss how this solves critical organization pain points.
Problem We Solved

Before this architecture was implemented, our organization faces a classic set of scaling problems.

    Manual and risky deployments: Engineers were manually running docker build, pushing to registries, and executing helm upgrade or kubectl apply from their local machines. This caused configuration drift and downtime

    Lack of Security Gates: Unscanned container images with unpatched CVEs were making it to production, and secrets were occassionally hardcoded into config files.

    "Working on my machine Syndrome": Developers were spinning up kubernetes clusters with varying configurations, leading to inconsistent testing.

    Slow Feedback Loops: Developers had to wait for DevOps team to manually provision ArgoCD applications for new microservices.

The solution proposed after delibration with teams was to implement a self-service GitOps-driven development lifecycle, by combining Terraform (to provision identical environment locally or in cloud), GitHub Actions for secure CI, ArgoCD for automated CD, thus eliminating manual interventions.
Prerequisites

Ensure you have the following tools installed on your local machine:

    Docker Desktop
    Python 3.x
    Terraform
    Kubectl
    Minikube or Kind (for local Kubernetes)
    Helm

High Level Architecture

    The application: A simple python flask application that returns the current server time.

    IaC (Terraform): Provisions a local Minikube cluster via Docker driver and installs Argo CD via Helm.

    CI (GiitHub Actions): Scans for secrets (Gitleaks), builds and scan Docker image (Trivy), pushes it to Docker Hub, and automatically updates the Helm chart image tag in the repository.

    CD (GitOps via ArgoCD): Monitors the repository as the CI pipeline updates the Helm chart values, ArgoCD detects the drift and seamlessly rolls out the new deployment.

Application & Containerization

    Clone the Repository

1. git clone git clone https://github.com/mosesadelere/terra_deploy.git
2. cd terra_deploy

    Navigate to Settings -> Secrets and variables -> Actions in your GitHub repository.

    Add the following:
        Secrets: DOCKERHUB_TOKEN (Generate an access token in your Docker Hub account settings).
        Variables: DOCKERHUB_USERNAME Your DockerHub username

    Open .github/workflows/ci.yaml and ensure the image name mosesade/complete-devops-project is updated to <your-dockerhub-username>/complete-devops-project in the build and push steps.

Provisioning Local cluster

We use Terraform to ensure every engineer gets the exact same local kubernetes cluster without manually typing minikube start.

    Initialise and apply the Terraform code:

1. terraform Init
2. terraform plan
3. terraform apply -auto-approve

    Event that transpire

Terraform used the minikube provider to create a cluster named complete-devops-project running kubernetes using the local Docker engine.

    Verify your kubectl context is pointing to the new cluster:

kubectl config use-context complete-devops-project
kubectl get nodes

Deploying ArgoCD

During terraform apply, Terraform also executed argocd.tf, which installed the ArgoCD Helm chart into the argocd namespace

    Verify ArgoCD pods are running

1. kubectl get pods -n argocd

    Apply the Application Manifest: Tell ArgoCD to start monitoring our Helm chart directory.

1. kubectl apply -f argocd-app.yaml

    Access the ArgoCD UI:

1. kubectl port-forward svc/argocd-server -n argocd 8080:443

    Get the Admin Password:

1. kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

Login at https://localhost:8080 with username admin and the password of the above command.
Trigger the pipeline to observe GitOps

Lets see the magic of the GitOps in real time.

    Open ``àpp.py``` and change the time format string to any acceptable of your choice.

    Commit and push the changes to your master branch:

1. git add app.py
2. git commit -m "Updated time format"
3. git push origin master

    Goto the Actions tab in your GitHub repo. You will see the pipeline:

    Run Gitleaks to prevent credential leaks, and if the is a leak, the CI will abort.
    Build the docker image
    Run Trivy: this ensures no critical CVEs exist in the OS/libraries
    Push the image to Docker Hub with Git short SHA as the tag of each built.
    For each built, the tag is updated in complete-devops-project-time-printer/values.yaml and pushes that change to the repo.

    Watch ArgoCD: Go back to ArgoCD UI. In few minutes, ArgoCD will detect that the values.yamlfile in Git has changed (Config drift). It will automatically pull the new image and roll out a new pod.

    Access the App: The Flask app is expose via clusterIP on port 2222. Port-forward it locally:

1. kubectl port-forward svc/complete-devops-project-time-printer 8081:2222

Visit http://localhost:8081 in your browser to see your updated time format.

------------------------------------------ Finish --------------------------------------------------