import { defineConfig } from "@mami/cli";
import * as hexo from "@mami/plugin-hexo";
import * as joplin from "@mami/plugin-joplin";
// import json from "./.joplin-blog.json";

export default defineConfig({
  // input: [joplin.input(json)],
  input: [
    joplin.input({
      baseUrl: "http://127.0.0.1:41184",
      token:
        "7165b277170f033130c0dfd995ed4b410008c0b167263b59dd72f3bd7c831bff40febd988a7655e857f7be42b166064394417692f95690bc672768a9120e752f",
      tag: "blog",
    }),
  ],
  output: [hexo.output()],
});
