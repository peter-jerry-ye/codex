///|
async fn main {
  @async.with_task_group(taskgroup => {
    let codex = @codex.Codex::new(
      taskgroup~,
      options=@codex.CodexOptions::new(base_url="https://openrouter.ai/api/v1"),
    )
    let thread = codex.start_thread(
      options=@codex.ThreadOptions::new(model="anthropic/claude-sonnet-4"),
    )
    try {
      let turn = thread.run("Hello?")
      println(turn.final_response)
      println(turn.items.to_json().stringify())
      println(turn.usage.to_json().stringify())
    } catch {
      e => println(e)
    }
  })
}
