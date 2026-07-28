

.
├── .gitattributes  (add into scaffold root + bootstrap updated with lfs init)
├── .githooks
│   ├── post-checkout
│   ├── post-commit
│   ├── post-merge
│   ├── pre-commit
         1. (add script to scaffold root) - done
         2. requires uv to be installed (add to bootstrap) - done
         3. requires scripts/ci/export_ods_to_csv.py -done
         4. ?? are created .sh file executable by default? (if not find way to make it executable) -done
         5. how to configure git to use the pre-commit hook? (add to bootstrap)  - done
│   └── pre-push
├── .github
│   ├── ISSUE_TEMPLATE
│   │   └── issue-discovery.md - done
│   ├── pull_request_template.md - done
│   ├── skills/
│   │   ├── bezpecnost
│   │   │   └── SKILL.md - done
│   │   ├── hranicni
│   │   │   └── SKILL.md - done
│   │   ├── jsdoc
│   │   │   └── SKILL.md - done
│   │   ├── pojmenuj
│   │   │   └── SKILL.md - done
│   │   ├── proc
│   │   │   └── SKILL.md - done
│   │   ├── refaktor
│   │   │   └── SKILL.md - done
│   │   ├── testuj-e2e
│   │   │   └── SKILL.md - done
│   │   ├── testuj-unit
│   │   │   └── SKILL.md - done
│   │   ├── vysvetli
│   │   │   └── SKILL.md - done
│   │   └── zkontroluj
│   │       └── SKILL.md - done
│   └── workflows
│       ├── ci-export-ods-to-csv.yml - done
│       └── ci.yml - done
├── docs
│   ├── infra
│   │   ├── ci
│   │   │   └── .gitkeep - done
│   │   └── templates
│   │       ├── CIO-XXX-ci-documentation-overview-[template].md - done
│   │       └── CIP-ci-pipeline-[ciName]-[template].md - done
│   ├── product
│   │   ├── architecture
│   │   │   ├── .gitkeep - done
│   │   │   ├── templates
│   │   │   │   └── ui - done
│   │   │   └── ui
│   │   │       ├── lo-fi_wireframe - done
│   │   │       └── ui-flows - done
│   │   ├── delivery  - done
│   │   │   └── releases  - done
│   │   │       └── .gitkeep  - done
│   │   └── discovery  - done
│   │       ├── artifacts  - done
│   │       │   └── .gitkeep  - done
│   │       ├── assumptions
│   │       │   └── .gitkeep  - done
│   │       ├── business-problem
│   │       │   └── .gitkeep  - done
│   │       ├── decisions
│   │       │   └── .gitkeep  - done
│   │       ├── experiments
│   │       │   └── .gitkeep  - done
│   │       ├── requirements
│   │       │   └── .gitkeep  - done
│   │       └── templates
│   │           ├── 01-problem-framing - done
│   │           ├── 02-assumptions - done
│   │           ├── 03-discovery-techniques - done
│   │           ├── 04-experiments - done
│   │           ├── 05-decisions - done
│   │           ├── 06-risks - done
│   │           ├── 07-product-requirements-definition - done
│   │           └── 08-runbook - done
│   ├── project-governance
│   │   └── product-discovery
│   │       ├── assets -done
│   │       │   ├── discovery-cheat-sheet-image.png
│   │       │   ├── SW_Delivery_High-level_Flowchart.drawio
│   │       │   └── SW_Delivery_High-level_Flowchart.drawio.png
│   │       ├── discovery-technique-guide.md - done
│   │       └── product-discovery-guide-simple.md - done
│   └── risk
│       └── .gitkeep
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