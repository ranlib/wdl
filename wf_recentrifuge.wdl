version 1.0

import "./task_recentrifuge.wdl" as recentrifuge

workflow wf_recentrifuge {
    input {
      File input_file
      File nodes_dump
      File names_dump
      String docker
      String format
      String outprefix
      String output_type
      String input_type
      Int controls_number
      Int taxid
    }
    
    call recentrifuge.task_recentrifuge {
      input:
      docker = docker,
      input_file = input_file,
      outprefix = outprefix,
      format = format,
      nodes_dump = nodes_dump,
      names_dump = names_dump,
      output_type = output_type,
      input_type = input_type,
      controls_number = controls_number,
      taxid = taxid
    }
    
    output {
        Array[File] rcf_output = task_recentrifuge.outputs
    }
}
