#!/usr/bin/env python3

import fcntl
import os
import sqlite3
import sys
from contextlib import closing
from pathlib import Path


def main():
    build = Path(sys.argv[1]).absolute()
    main_database = build / "build.db"
    plugin_database = build / "plugin-tools.db"
    if not main_database.is_file() or not plugin_database.is_file():
        return

    # Match TSCBasic.FileLock.prepareLock, including symlinks and NAME_MAX.
    # .build/.lock only stores a PID; SwiftPM's actual lock is in TMPDIR.
    lock_name = str(build.parent.resolve() / build.name).replace("/", "_").replace(":", "_") + ".lock"
    temporary_directory = Path(os.environ["TMPDIR"])
    name_max = os.pathconf(temporary_directory, "PC_NAME_MAX")
    lock_name = lock_name.encode("utf-8")[-name_max:].decode("utf-8", errors="ignore")

    with (temporary_directory / lock_name).open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        with closing(sqlite3.connect(main_database.as_uri() + "?mode=rw", uri=True)) as source:
            with closing(sqlite3.connect(plugin_database.as_uri() + "?mode=rw", uri=True)) as destination:
                source_version = source.execute("SELECT version, client_version FROM info").fetchone()
                destination_version = destination.execute("SELECT version, client_version FROM info").fetchone()
                if source_version != destination_version:
                    return

                # Native SwiftPM uses separate databases for shared host outputs.
                # Seed the next plugin-tools build from the completed main build.
                # SQLite backup handles journals atomically; llbuild still validates
                # every command signature and input before reusing a cached result.
                source.backup(destination)


if __name__ == "__main__":
    try:
        main()
    except (OSError, sqlite3.Error) as error:
        sys.exit(f"Could not synchronize SwiftPM plugin build cache: {error}")
