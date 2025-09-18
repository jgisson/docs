# Jujutsu (jj) - Version Control System Refcard

## Overview
Jujutsu (jj) is a Git-compatible distributed version control system that simplifies complex workflows and provides a more intuitive interface.

## Installation

### macOS
```bash
# Using Homebrew
brew install jj

# Using MacPorts
sudo port install jujutsu
```

### Linux
```bash
# Ubuntu/Debian
curl -L https://github.com/martinvonz/jj/releases/latest/download/jj-v*-x86_64-unknown-linux-musl.tar.gz | tar xzv
sudo mv jj /usr/local/bin/

# Arch Linux
pacman -S jujutsu

# Fedora
dnf install jujutsu
```

### Windows
```powershell
# Using Scoop
scoop install jujutsu

# Using Chocolatey
choco install jujutsu
```

## Basic Setup

### Initial Configuration
```bash
# Set your identity
jj config set --user user.name "Your Name"
jj config set --user user.email "your.email@example.com"

# Set default editor
jj config set --user ui.editor "code --wait"  # VS Code
jj config set --user ui.editor "vim"          # Vim
```

### Initialize Repository
```bash
# Initialize new repo
jj init my-project
cd my-project

# Initialize in existing directory
jj init .

# Clone from Git repository
jj git clone https://github.com/user/repo.git
```

## Basic Commands

### Repository Status & History
```bash
jj status                   # Show working copy status
jj log                      # Show commit history (graph view)
jj log -r @                 # Show current revision
jj log -r 'all()'           # Show all revisions
jj show                     # Show current change details
jj show REVISION            # Show specific revision details
```

### Making Changes
```bash
jj new                      # Create new empty change
jj new REVISION             # Create change based on revision
jj describe                 # Edit current change description
jj describe -m "message"    # Set change description
jj abandon                  # Abandon current change
```

### File Operations
```bash
jj files                    # List tracked files
jj diff                     # Show changes in working copy
jj diff REVISION            # Show changes since revision
jj track PATH               # Start tracking file
jj untrack PATH             # Stop tracking file
```

### Branch Management
```bash
jj branch list                # List all branches
jj branch create NAME         # Create new branch
jj branch create NAME -r REV  # Create branch at revision
jj branch delete NAME         # Delete branch
jj branch rename OLD NEW      # Rename branch
jj branch set NAME -r REV     # Move branch to revision
```

### Navigation & Checkout
```bash
jj edit REVISION            # Edit (checkout) revision
jj next                     # Move to child revision
jj prev                     # Move to parent revision
jj bookmark REVISION        # Create bookmark at revision
```

### Merging & Rebasing
```bash
jj merge REV1 REV2          # Merge two revisions
jj rebase -r REV -d DEST    # Rebase revision to destination
jj rebase -s SOURCE -d DEST # Rebase source and descendants
jj resolve                  # Resolve merge conflicts
```

### Working with Git
```bash
jj git fetch                # Fetch from Git remote
jj git push                 # Push to Git remote
jj git push --branch BRANCH # Push specific branch
jj git import               # Import Git refs
jj git export               # Export to Git
```

### Splitting & Squashing
```bash
jj split                    # Split current change interactively
jj split -i                 # Split current change (interactive)
jj squash                   # Squash current change into parent
jj squash -r REV            # Squash specific revision
```

### Undoing Changes
```bash
jj undo                     # Undo last operation
jj undo -o OPERATION        # Undo specific operation
jj restore PATH             # Restore file from parent
jj restore --from REV PATH  # Restore file from revision
```

## Advanced Commands

### Revsets (Revision Selection)
```bash
@                           # Current working copy
@-                          # Parent of working copy
@+                          # Children of working copy
main                        # Branch named 'main'
HEAD                        # Git HEAD
'author(name)'              # Revisions by author
'description(text)'         # Revisions with description containing text
'empty()'                   # Empty revisions
'all()'                     # All revisions
```

### Configuration
```bash
jj config list              # Show all configuration
jj config get KEY           # Get configuration value
jj config set KEY VALUE     # Set configuration value
jj config edit              # Edit configuration file
```

### Templating & Formatting
```bash
jj log -T 'commit_id.short() " " description.first_line()'
jj log -T 'branches " " commit_id " " description'
```

## Useful Aliases

Add to your `~/.jjconfig.toml`:

```toml
[aliases]
l = ["log", "-r", "(main..@):: | (main..@)-"]
ll = ["log"]
st = ["status"]
d = ["diff"]
n = ["new"]
e = ["edit"]
```

## Tips & Best Practices

1. **Always work in changes**: Jujutsu encourages working in explicit changes rather than modifying files directly
2. **Use descriptive messages**: `jj describe` helps document your changes
3. **Leverage revsets**: Learn revset syntax for powerful revision selection
4. **Regular sync**: Use `jj git fetch` and `jj git push` to stay in sync with Git remotes
5. **Explore history**: `jj log` provides excellent visualization of your commit graph

## Common Workflows

### Feature Development
```bash
jj new main -m "Start feature X"      # Create new change from main
# Make changes...
jj describe -m "Implement feature X"  # Update description
jj git push --branch feature-x        # Push to remote
```

### Fixing Previous Change
```bash
jj edit REVISION                    # Edit the problematic revision
# Make fixes...
jj describe -m "Fixed issue in ..."  # Update description
```

### Code Review Updates
```bash
jj new @- -m "Address review comments"  # Create fixup change
# Make changes...
jj squash                              # Squash into previous change
```

## Help & Documentation

```bash
jj help                     # General help
jj help COMMAND             # Help for specific command
jj tutorial                 # Interactive tutorial
```

## Resources

- [Official Documentation](https://github.com/jj-vcs/jj)
- [GitHub Repository](https://github.com/jj-vcs/jj)
