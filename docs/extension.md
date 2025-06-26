# Extension Proposal
This document presents a primary extension along with additional proposals to enhance the project's deployment and release infrastructure.

## Automated Canary Promotion

In our current setup, we have implemented canary releases using the Istio service mesh, with traffic split 90/10 between the stable and canary versions. However, promoting a canary version to full production currently requires manual intervention: adjusting the Istio `VirtualService` configuration, reapplying it to the cluster, and verifying performance metrics by hand.

This manual process introduces several release-engineering shortcomings. It is error-prone, as misconfigurations during traffic shifting can cause outages or degraded performance. It is time-consuming, requiring engineers to monitor metrics and manually adjust routing. It is also non-repeatable, as decisions are made on a case-by-case basis, which might cause inconsistency across deployments and increases operational overhead.

To address this, we propose implementing automated canary promotion using Flagger. Flagger integrates with Istio and Prometheus to automate traffic shifting and canary promotion based on real-time performance metrics such as error rate and latency. If the canary version remains healthy, Flagger gradually increases its traffic share until it is fully promoted to production. This approach is inspired by the Flagger's official [Istio Canary Deployments tutorial](https://docs.flagger.app/tutorials/istio-progressive-delivery#automated-canary-promotion), which explains how to define canary analysis thresholds, steps, and rollback conditions, and could be directly applied to our deployment pipeline.

To evaluate the impact of this extension, we would design an experiment comparing the current manual promotion process with the automated one. Key metrics would include time to full promotion, user-experience indicators (e.g., latency, error rate), number of misconfigurations or rollbacks, and required developer effort (manual steps or interventions). Tracking these across several releases would provide quantitative evidence of improved efficiency and reliability.

This solution is not specific to our project alone. Automated canary promotion via Flagger is a generalizable improvement applicable to any Kubernetes-based deployment using Istio and Prometheus. Because it automates the manual process of canary promotion and defines measurable rules for traffic shifting and rollback, it eliminates human error and standardizes decision-making. It encourages safer releases, reduces cognitive load on engineers, and supports consistent deployment.

## Other shortcomings and proposed extensions:

#### 1.Dynamic Model Training
In our current setup, model training is done offline. During runtime we collect user-submitted and self-labelled data, but we do not yet utilise this during runtime.

One notable observation that was made during testing was the shortcoming of the CountVectorizer, as it is only able to encode a limited vocabulary. In the case that user-submitted words do not match this dictionary, they are excluded from evaluation - potentially gravely impacting the performance of the application.

In order to mitigate this, we can define a set number of `n` model-services deployed in parrallel. Upon receiving a request for scoring a review the Istio Service Mesh routes the call based on the efficacy of the different models' encoder; this can be done either deterministically or probabilistically.

Periodically, either at random or based on overall performance, each model-service invokes a new round of training based on the user-labelled dataset is has built up. It is important that the dataset be randomized for this step, so as to not preserve an identical encoder.

#### 2.Online Model Replacement
Partially as a requirement for the above mentioned extension, a pipeline would have to be added for bringing new models online. Though it would be viable to spin up a new Container with a "freshly trained" model, a more palatable approach may be to simply change wich model files are loaded by the module.

Currently, the core infrastructure for such a change is in place - all that is missing is the pathways for invoking the switch.

#### 3.Admin API
In order to configure such changes, setting up an administrative API with some form of authentication (i.e. OAuth) would enable administrators to manually execute tasks such as the aforementioned model change, without requiring direct interfacing with the containers.

#### 4.Automated Updates
When in a deployment environment, using an Admin API as described above, a GitHub Workflow could make an authenticated API call to inform the deployment of an update to its code base. On minor patches, the application could then be configured to automatically install these newer versions - potentially via a canary release - to ensure an up-to-date deployment. This feature would be of particular interest in the case of security vulnerabilities.

#### 5.Automated Fallback
In the event that a newest version proves unexpectedly unreliable (unstable, unsecure, user-unfriendly) we would ideally fall back to a prior version. Though this could be done automatically in some cases (e.g. server crashes, extreme metric values), we would also want to be able to envoke this automated fallback via administrative input.
