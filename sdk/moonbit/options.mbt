// codexOptions.ts

///|
/// Options for configuring the Codex client.
pub struct CodexOptions {
  /// Override the path to the codex executable
  codex_path_override : String?
  /// Base URL for the API
  base_url : String?
  /// API key for authentication
  api_key : String?
} derive (
  ToJson(rename_fields="camelCase"),
  @json.FromJson(rename_fields="camelCase"),
)

// threadOptions.ts

///|
/// Approval mode for actions that require user consent.
pub enum ApprovalMode {
  /// Never ask for approval
  Never
  /// Ask for approval on request
  OnRequest
  /// Ask for approval on failure
  OnFailure
  /// Ask for approval for untrusted actions
  Untrusted
}

///|
pub impl ToJson for ApprovalMode with to_json(mode) {
  match mode {
    Never => "never"
    OnRequest => "on-request"
    OnFailure => "on-failure"
    Untrusted => "untrusted"
  }
}

///|
pub impl @json.FromJson for ApprovalMode with from_json(value, path) {
  match value {
    String("never") => Never
    String("on-request") => OnRequest
    String("on-failure") => OnFailure
    String("untrusted") => Untrusted
    _ =>
      raise @json.JsonDecodeError(
        (path, "expected approval mode string, got \{value}"),
      )
  }
}

///|
/// Sandbox mode that controls the level of access the agent has.
pub enum SandboxMode {
  /// Read-only access
  ReadOnly
  /// Write access to workspace
  WorkspaceWrite
  /// Full access (dangerous)
  DangerFullAccess
}

///|
pub impl ToJson for SandboxMode with to_json(mode) {
  match mode {
    ReadOnly => "read-only"
    WorkspaceWrite => "workspace-write"
    DangerFullAccess => "danger-full-access"
  }
}

///|
pub impl @json.FromJson for SandboxMode with from_json(value, path) {
  match value {
    String("read-only") => ReadOnly
    String("workspace-write") => WorkspaceWrite
    String("danger-full-access") => DangerFullAccess
    _ =>
      raise @json.JsonDecodeError(
        (path, "expected sandbox mode string, got \{value}"),
      )
  }
}

///|
/// Options for configuring a thread.
pub struct ThreadOptions {
  /// The model to use for the thread
  model : String?
  /// The sandbox mode
  sandbox_mode : SandboxMode?
  /// The working directory
  working_directory : String?
  /// Whether to skip git repository check
  skip_git_repo_check : Bool?
} derive (
  ToJson(rename_fields="camelCase"),
  @json.FromJson(rename_fields="camelCase"),
)

// turnOptions.ts

///|
/// Options for configuring a turn.
pub(all) struct TurnOptions {
  /// JSON schema describing the expected agent output
  output_schema : Json?
} derive (
  ToJson(rename_fields="camelCase"),
  @json.FromJson(rename_fields="camelCase"),
)
