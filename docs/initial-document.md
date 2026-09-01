# This is temporary file

## Architecture decision record (ADR) 1

This is prelimary notes for futher code refactoring.

I need to use local project directory path in multiple modules. The path is created in bootstrap module and saved in a temporary file. 

Problem 1: The file must be available to other modules, with correct path, and must be read from the temporary file. Clearing the temp file is no good idea because other modules may need to read the path from the temp file.

Problem 2: The temp file contains the path, hence its not good idea to commit the temp file to version control.

Solution: 
1. Temp file will not be version controlled (see .gitignore).
2. Once repo is cloned and bootstrap module runs successfully, the temp file will be created with the path. Other modules can read the path from the temp file.
3. If new project with new path is created, the bootstrap module will overwrite the temp file with the new path. Other modules can read the new path from the temp file. 

Note: Think of changing `temp` to `state` as the temp file is not really temporary, it is a persistent state file that is used to store the project path.