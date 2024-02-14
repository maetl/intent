# Intent

## Project configuration

Registered project configuration is defined in the `PROJECTS` file in todo.txt notation.

The main text of the list item provides a descriptive title for the project.

The project ID is defined using the todo.txt `+project` syntax.

```
Calyx +calyx
Big Ball of Mud +bbom
```

Additional project tags.

```
has:milestones
has:goals
has:notes
has:artboards
has:releases
has:principles
has:roadmap
has:deadline
is:book
is:research
is:product
is:game
is:storyworld
state:active
state:
```

# Enabling context configuration

Context configuration is defined in the `CONTEXTS` file with KDL notation.

```kdl
CONTEXTS {
  git {
    github host="github" uri="https://github.com/{org}/{repo}"
    gitlab host="id-git" uri="https://id.institution.code/{org}/{repo}"
  }

  reading {
    launch_url "chrome-cli --args {href}"
    launch_pdf "pdf-reader"
  }
}
```

## Enabling metadata configuration

Metadata tag configuration is defined in the `TAGS` file with KDL notation.

```kdl
TAGS {
  due belongs_to="deadline" type="date"
  
}
```

## Initializing a project directory

```
project init +demo
```

## Linking notes to a project directory



# Adding project elements

```
project add goals +demo
project add notes +demo
```

## Git repository context

Add `@git` to a todo line to attach it to the managed repository context.

Supported tags in todo lines:

- **host**, label of remote hosting platform, eg: `host:github`, `host:eng-git`
- **org**, GitHub/GitLab user or organisation, eg: `org:maetl`, `org:fictiveworks`, `org:mor30`
- **repo**, remote repository name, eg: `repo:intent`, `repo:fictive-studio`, `repo:dammed`
- **issue**, issue identifier if needed, eg: `issue:83`
- **branch**, name of remote branch if needed, eg: `branch:feature-id`, `branch:development`

Example:

```
Refactor spline reticulator to support spline threshold cap +simdemo @git host:github org:maetl repo:simdemo-js issue:3
```

If the project has managed repository details available by default, these are used in the `@git` context if no tag is provided in the todo line.