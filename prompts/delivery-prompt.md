Source : https://harper.blog/2025/02/16/my-llm-codegen-workflow-atm/

From here you should have the foundation to provide a series of prompts for a code-generation LLM that will implement each step. Prioritize best practices by following the existing code, and incremental progress, ensuring no big jumps in complexity at any stage. Make sure that each prompt builds on the previous prompts, and ends with wiring things together. There should be no hanging or orphaned code that isn't integrated into a previous step.

Make sure and separate each prompt section. Use markdown. Each prompt should be tagged as text using code tags. The goal is to output prompts, but context, etc is important as well.

Implementation plan : <Implementation plan>