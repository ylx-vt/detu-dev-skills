# detu-dev-skills

得荼的开发技能。

个人开发技能包仓库，用于沉淀可复用的实战型技能（Skills）。

This is my personal repository of reusable development skills.

## 当前版本 | Version

- `v0.1.0` (starting point)

## 仓库目标 | Repository Purpose

- 沉淀可重复执行的工程技能
- 用于个人知识复用与 Agent 技能调用
- 优先提供可直接执行的 CLI 工作流

- Capture repeatable engineering skills
- Reuse in personal workflows and agent-driven tasks
- Prefer directly executable CLI-first workflows

## 目录结构 | Structure

```text
skills/
  vpn-server-cli/
    SKILL.md
```

## 已收录技能 | Included Skills

1. `vpn-server-cli`: 服务器端自建 Shadowsocks + 防火墙 + Nginx 订阅发布（纯 CLI）

## 使用方式 | Usage

1. 进入目标技能目录
2. 阅读 `SKILL.md`
3. 按步骤在对应环境执行

1. Open the target skill directory
2. Read `SKILL.md`
3. Execute steps in the target environment

## 一键安装到 Codex | Install To Codex

默认安装本仓库全部技能到 `~/.codex/skills`（或 `$CODEX_HOME/skills`）：

Install all skills into `~/.codex/skills` (or `$CODEX_HOME/skills`):

```bash
./scripts/install.sh
```

只安装单个技能：

Install one skill only:

```bash
./scripts/install.sh --skill vpn-server-cli
```

安装到自定义目录（例如测试目录）：

Install to a custom destination:

```bash
./scripts/install.sh --dest /tmp/codex-skills-test
```

## 声明 | Notice

本仓库内容仅用于个人学习、运维与安全研究，请遵守所在地法律法规与服务商条款。

This repository is for personal learning, operations, and security research only. Follow local laws and provider terms.
