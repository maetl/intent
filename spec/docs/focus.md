# Focus 

This represents a short concentration span of 3 hours to 3 days, focusing on a particular project or combination of projects with an unspecified outcome.

This supports both open-ended R&D exploration and a complex set of subgoals which are not worth trying to encode at this level of personal knowledge management (more appropriate would be to use a tool adapted to the specific project, Trello, JIRA, GitHub etc).

## Context marker 

The focus for a particular day can be recorded in the todo ledger file, indicated by the `@focus` context marker.

No notes are required, but can be added if additional explanation or records of ideas are helpful.

## Focus command

`focus` is the most basic ledger entry command. It writes a basic line item with the given projects.

### Single project Example

```
todo focus +project-id
```

Writes:

```
2024-02-01 @focus +project-id
```

### Multiple project example

```
todo focus +primary +supporting
```

Writes:

```
2024-02-01 @focus +primary +supporting
```

### Unmapped project error

```
todo focus +hello
```

Error:

```
+hello is not mapped to an active project
```

### Focused tasks exist error

```
todo focus +start-new-thing +newidea
```

Error:

```
+start-new-thing and +idea cannot be focused until the following tasks are closed:

2024-01-29 Working on old idea @focus +oldidea
```

## Add command

To write additional notes and comments, use `add`.

Arg concept: To opt into additional focus checks, use `-f` or `--focus`

### Focus notes example

```
todo add @focus "Rolled a nat 20" +project-id
```

Writes:

```
2024-02-01 Rolled a nat 20 @focus +project-id
```
