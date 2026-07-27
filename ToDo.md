

.
├── .gitattributes  (add into scaffold root + bootstrap updated with lfs init)
├── .githooks
│   ├── post-checkout
│   ├── post-commit
│   ├── post-merge
│   ├── pre-commit
         1. (add script to scaffold root) - done
         2. requires uv to be installed (add to bootstrap) - done
         3. requires scripts/ci/export_ods_to_csv.py
         4. ?? are created .sh file executable by default? (if not find way to make it executable)
         5. how to configure git to use the pre-commit hook? (add to bootstrap) 
│   └── pre-push
├── .github
│   ├── ISSUE_TEMPLATE
│   │   └── issue-discovery.md
│   ├── pull_request_template.md
│   ├── skills
│   │   ├── documentace-jsdoc
│   │   │   └── SKILL.md
│   │   └── vysvetli
│   │       └── SKILL.md
│   └── workflows
│       ├── ci-export-ods-to-csv.yml
│       └── ci.yml
├── docs
│   ├── infra
│   │   ├── ci
│   │   │   └── .gitkeep
│   │   └── templates
│   │       ├── CIO-XXX-ci-documentation-overview-[template].md
│   │       └── CIP-ci-pipeline-[ciName]-[template].md
│   ├── product
│   │   ├── architecture
│   │   │   ├── .gitkeep
│   │   │   ├── templates
│   │   │   │   └── ui
│   │   │   └── ui
│   │   │       ├── lo-fi_wireframe
│   │   │       └── ui-flows
│   │   ├── delivery
│   │   │   └── releases
│   │   │       └── .gitkeep
│   │   └── discovery
│   │       ├── artifacts
│   │       │   └── ART-001-JTBD.md
│   │       ├── assumptions
│   │       │   ├── ART-002-assumption-list.md
│   │       │   └── ART-003-assumptions-backlog.md
│   │       ├── business-problem
│   │       │   └── BP-001-business-problem.md
│   │       ├── decisions
│   │       │   └── PDR-001-product-decision-record.md
│   │       ├── experiments
│   │       │   ├── ART-005-survey.md
│   │       │   ├── ATR-004-experiments-backlog.md
│   │       │   ├── EVI-001-evidence.md
│   │       │   ├── EXP-002-dark-mode
│   │       │   ├── EXP-003-quick-action-location
│   │       │   ├── EXP-XXX-name
│   │       │   └── HYP-001-hypothesis.md
│   │       ├── requirements
│   │       │   ├── BL-product-backlog.ods
│   │       │   └── exportsCSV
│   │       └── templates
│   │           ├── 01-problem-framing
│   │           ├── 02-assumptions
│   │           ├── 03-discovery-techniques
│   │           ├── 04-experiments
│   │           ├── 05-decisions
│   │           ├── 06-risks
│   │           ├── 07-product-requirements-definition
│   │           └── 08-runbook
│   ├── project-governance
│   │   └── product-discovery
│   │       ├── assets
│   │       │   ├── discovery-cheat-sheet-image.png
│   │       │   ├── SW_Delivery_High-level_Flowchart.drawio
│   │       │   └── SW_Delivery_High-level_Flowchart.drawio.png
│   │       ├── discovery-technique-guide.md
│   │       └── product-discovery-guide-simple.md
│   └── risk
│       ├── exportsCSV
│       │   ├── RSK-001-risk-register_Metadata.csv
│       │   ├── RSK-001-risk-register_Risk_Register.csv
│       │   └── RSK-001-risk-register_Scoring.csv
│       └── RSK-001-risk-register.ods
├── image-1.png
├── image.png
├── README.md
├── scripts
│   ├── bootstrap
│   │   ├── bootstrap.sh
│   │   └── git
│   │       └── git-config.sh
│   └── ci
│       └── export_ods_to_csv.py