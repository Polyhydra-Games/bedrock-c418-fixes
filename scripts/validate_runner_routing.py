#!/usr/bin/env python3
"""Static and behavioral contract checks for trusted GitHub Actions routing."""

from __future__ import annotations

from pathlib import Path


TRUSTED_LABELS = '["self-hosted", "Linux", "X64", "docker"]'
TRUSTED_RUNNER_EXPRESSION = (
    "${{ ((github.event_name != 'pull_request') || "
    "(github.event.pull_request.head.repo.full_name == github.repository && "
    "github.event.pull_request.user.login == github.repository_owner && "
    "github.actor == github.repository_owner)) && "
    f"fromJSON('{TRUSTED_LABELS}') || 'ubuntu-latest' }}"
)


def selected_runner(
    event_name: str,
    head_repository: str,
    repository: str,
    pull_request_user: str,
    repository_owner: str,
    actor: str,
) -> str:
    trusted_pull_request = (
        head_repository == repository
        and pull_request_user == repository_owner
        and actor == repository_owner
    )
    return TRUSTED_LABELS if event_name != "pull_request" or trusted_pull_request else "ubuntu-latest"


def assert_routing_contract() -> None:
    root = Path(__file__).resolve().parents[1]
    for relative_path in (".github/workflows/ci.yml", ".github/workflows/public-readiness-audit.yml"):
        workflow = (root / relative_path).read_text(encoding="utf-8")
        assert f"runs-on: {TRUSTED_RUNNER_EXPRESSION}" in workflow, (
            f"{relative_path} must use the approved trusted-runner expression"
        )
        assert "secrets." not in workflow, f"{relative_path} must not map secrets into fork-capable jobs"

    trusted = dict(
        event_name="pull_request",
        head_repository="Polyhydra-Games/bedrock-c418-fixes",
        repository="Polyhydra-Games/bedrock-c418-fixes",
        pull_request_user="Polyhydra-Games",
        repository_owner="Polyhydra-Games",
        actor="Polyhydra-Games",
    )
    assert selected_runner(**trusted) == TRUSTED_LABELS
    assert selected_runner(**(trusted | {"head_repository": "contributor/bedrock-c418-fixes"})) == "ubuntu-latest"
    assert selected_runner(**(trusted | {"pull_request_user": "contributor"})) == "ubuntu-latest"
    assert selected_runner(**(trusted | {"actor": "contributor"})) == "ubuntu-latest"
    assert selected_runner(**(trusted | {"event_name": "push"})) == TRUSTED_LABELS


if __name__ == "__main__":
    assert_routing_contract()
    print("Trusted-runner routing contract: OK")
