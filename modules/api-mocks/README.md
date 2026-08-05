# Title TBD

This is placeholder for `api-mocks` module documentation. It will be used to provide a fake backend for frontend development and testing.

**Decision:** 
- Use `MSW` (Mock Service Worker) as its browser mocking library. Angular dont know if talking to a real backend or a fake backend, hence you can mock real backend API calls with MSW. It will intercept the requests and return mocked responses.
- Rpository location `./apps/api-mocks` in project root.

**Futher Steps:**

- describe how to setup MSW
- Describe how to use MSW in Angular project 