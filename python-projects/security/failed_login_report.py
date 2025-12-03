import collections
from pathlib import Path

LOG_PATH = Path(__file__).resolve().parents[2] / "data" / "auth_log_sample.txt"

def parse_failed_logins(path: Path):
    failed_by_ip = collections.Counter()
    failed_by_user = collections.Counter()

    with path.open("r", encoding="utf-8") as f:
        for line in f:
            if "Failed password" not in line:
                continue

            parts = line.split()

            try:
                user_index = parts.index("user") + 1
                user = parts[user_index]
            except ValueError:
                continue

            ip = parts[-3]  # token before "port"

            failed_by_ip[ip] += 1
            failed_by_user[user] += 1

    return failed_by_ip, failed_by_user


def main():
    if not LOG_PATH.exists():
        print(f"Log file not found at: {LOG_PATH}")
        return

    failed_by_ip, failed_by_user = parse_failed_logins(LOG_PATH)

    print("Failed logins by IP:")
    for ip, count in failed_by_ip.most_common():
        print(f"  {ip:15} {count}")

    print("\nFailed logins by username:")
    for user, count in failed_by_user.most_common():
        print(f"  {user:15} {count}")


if __name__ == "__main__":
    main()
