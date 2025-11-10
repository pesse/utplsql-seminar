# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **utPLSQL training/workshop repository** for teaching Test-Driven Development (TDD) with Oracle PL/SQL. The codebase uses a Star Wars theme (Death Star operations) to make learning more engaging. It contains progressive examples from basic to advanced testing concepts, with starter code and complete solutions in `_final/` directories.

**Target Environment:**
- Oracle Database XE 21c running in Docker/Podman
- utPLSQL v3.1.14 testing framework
- Schema name: `deathstar`
- Connection: `localhost:1521/xepdb1`

## Essential Commands

### Running Tests
```sql
-- Connect as deathstar user first
set serveroutput on

-- Run all tests
begin ut.run(); end;
/

-- Run specific test package
begin ut.run('ut_deathstar_friend_or_foe'); end;
/

-- Run by suitepath (hierarchical)
begin ut.run(':ut_deathstar.defense'); end;
/

-- View results as table (same content, different layout)
select * from table(ut.run('ut_deathstar_security_welcome'));
/
```

### Installing Code
```sql
-- Install all utilities and schema objects
@install/_install.sql

-- Install specific module
@Schema/SecuritySystem/_install.sql
@Schema/SoldierGroups/_install.sql

-- Reset demo scripts to starting state
@demos/00_reset_demos.sql
```

## Architecture and Patterns

### Directory Structure
- **Schema/**: Main application code organized by business domain
  - Each module contains tables, packages, tests, and `_install.sql`
  - `_final/` subdirectories contain complete solutions
  - Test packages use `ut_` prefix (e.g., `ut_deathstar_security`)
- **demos/**: Numbered step-by-step workshop scripts (01-06)
- **QuickCodeExamples/**: Standalone examples demonstrating specific features
- **utplsql-docs/**: Reference documentation for utPLSQL features
- **install/**: Environment setup scripts
- **utils/**: Shared utility packages (`utl_db_object`, `alignment_detector`)

### Testing Conventions

**Naming Conventions:**
- Test packages: `ut_<package_name>` (e.g., `ut_deathstar_security`)
- Object types: `t_<name>` prefix (e.g., `t_person_appearance`)
- Test data IDs: Use negatives to avoid conflicts (e.g., `planet_id = -1`)

**Essential Annotations:**
```sql
--%suite(Suite Description)                     -- Mark package as test suite (REQUIRED)
--%suitepath(path.to.suite)                     -- Organize into hierarchy
--%test(Test Description)                       -- Mark procedure as test (REQUIRED)
--%throws(exception_code)                       -- Expect specific exception
--%beforeeach / %aftereach                      -- Run before/after each test
--%context(Context Description) / %endcontext   -- Group related tests
--%name(context_name)                           -- Name a context (optional)
```

**Common Test Pattern:**
```sql
ut.expect(actual_value).to_equal(expected_value);
ut.expect(actual_cursor).to_equal(expected_cursor);
ut.expect(anydata.convertObject(obj)).to_equal(anydata.convertObject(expected_obj));
```

**See utplsql-docs/ for detailed information:**
- `annotations.md` - Complete annotation reference
- `expectations.md` - All matchers and expectation syntax
- `advanced_data_comparison.md` - Include/exclude, join_by, unordered
- `running-unit-tests.md` - Execution options and tag filtering

## Key Technical Details

### Module Dependencies
- **utils/**: Foundation utilities - install first
- **SoldierGroups/**: Complex module with internal/public structure
- **SecuritySystem/**: Depends on alignment_detector utility
- **DeathStarRooms/**: Standalone, no external dependencies

### Database Object File Extensions
- `.pks` = Package specification
- `.pkb` = Package body
- `.Table.sql` = Table definition
- `.View.sql` = View definition
- `.Trigger.sql` = Trigger definition
- `.tps` = Type specification

## Workshop Progression

1. **demos/01_first_test_friend_or_foe.sql** - Basic TDD cycle (Red-Green-Refactor)
2. **demos/02_advanced_friend_or_foe.sql** - Extended with more attributes
3. **demos/03_welcome_function.sql** - Testing string functions
4. **demos/04_welcome_function_full.sql** - Complex logic with edge cases
5. **demos/05_soldier_groups.sql** - Complex data structures and business rules
6. **demos/06_duplicate_compare_replace.sql** - Refactoring with test coverage

## Quick Reference - Common Patterns

### Advanced Data Comparison
```sql
-- Exclude volatile columns (timestamps, generated IDs, etc.)
ut.expect(l_actual).to_equal(l_expected).exclude('CREATE_DATE,LAST_MODIFIED');

-- Join by key for unordered comparison (much faster than .unordered)
ut.expect(l_actual).to_equal(l_expected).join_by('ID');

-- Ignore column order
ut.expect(l_actual).to_equal(l_expected).uc();
```

### Important Gotchas

1. **Annotation Placement**: NO blank lines between annotation and procedure
2. **Data Type Strictness**: `equal` matcher requires exact type match (VARCHAR2 ≠ NUMBER)
3. **Cursor Consumption**: Open cursors are consumed during comparison - can't reuse
4. **Column Names**: Case-sensitive in `include()`, `exclude()`, `join_by()`
5. **DATE Comparison**: DATE ignores time unless you call `ut.set_nls()` first
6. **Context Naming**: Use `--%context(Description)` then `--%name(identifier)` (not `--%displayname`)

## Special Notes for AI Assistants

- This is a **learning environment** - preserve both starter code and `_final/` solutions
- When modifying tests, maintain the TDD cycle: write failing test first, then implement
- Keep the Star Wars theme consistent (Death Star, Sith, Empire, lightsabers, etc.)
- Test data uses negative IDs by convention to distinguish from "production" data
- The annotation comments (`--%suite`, `--%test`) are parsed by utPLSQL - syntax matters
- Each demo script is self-contained and can be run independently after reset
