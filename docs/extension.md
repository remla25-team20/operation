# Extension Proposal
This document outlines several avenues of expanding the deployment and release infrastructure of this project.

## 1.Dynamic Model Training
In our current setup, model training is done offline. During runtime we collect user-submitted and self-labelled data, but we do not yet utilise this during runtime.

One notable observation that was made during testing was the shortcoming of the CountVectorizer, as it is only able to encode a limited vocabulary. In the case that user-submitted words do not match this dictionary, they are excluded from evaluation - potentially gravely impacting the performance of the application.

In order to mitigate this, we can define a set number of `n` model-services deployed in parrallel. Upon receiving a request for scoring a review the Istio Service Mesh routes the call based on the efficacy of the different models' encoder; this can be done either deterministically or probabilistically.

Periodically, either at random or based on overall performance, each model-service invokes a new round of training based on the user-labelled dataset is has built up. It is important that the dataset be randomized for this step, so as to not preserve an identical encoder.

### 2.Online Model Replacement
Partially as a requirement for the above mentioned extension, a pipeline would have to be added for bringing new models online. Though it would be viable to spin up a new Container with a "freshly trained" model, a more palatable approach may be to simply change wich model files are loaded by the module.

Currently, the core infrastructure for such a change is in place - all that is missing is the pathways for invoking the switch.

### 3.Admin API
In order to configure such changes, setting up an administrative API with some form of authentication (i.e. OAuth) would enable administrators to manually execute tasks such as the aforementioned model change, without requiring direct interfacing with the containers.

### 4.Automated Updates
When in a deployment environment, using an Admin API as described above, a GitHub Workflow could make an authenticated API call to inform the deployment of an update to its code base. On minor patches, the application could then be configured to automatically install these newer versions - potentially via a canary release - to ensure an up-to-date deployment. This feature would be of particular interest in the case of security vulnerabilities.

### 5.Automated Canary Promotion
Given the available parameters that are being collected through Prometheus, it would be feasible to parameterise the performance of a canary release - to observe whether any user metrics diverge from the expected range, or whether any bugs or crashes occur.

Should a canary release prove stable and usable, the routing rules could be updated to increase flow to the canary over time until we can be reasonably confident that the canary release does not negatively impact the user experience.

### 6.Automated Fallback
In the event that a newest version proves unexpectedly unreliable (unstable, unsecure, user-unfriendly) we would ideally fall back to a prior version. Though this could be done automatically in some cases (e.g. server crashes, extreme metric values), we would also want to be able to envoke this automated fallback via administrative input.
