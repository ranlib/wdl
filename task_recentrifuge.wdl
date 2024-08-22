version 1.0

task task_recentrifuge {
    input {
      File input_file
      File nodes_dump
      File names_dump
      String docker = "dbest/recentrifuge:v1.14.1"
      String outprefix
      String format
      String output_type
      String memory = "16GB"
      String input_type = "centrifuge"
      Int controls_number
      Int? taxid
    }

    String option = if (input_type == "centrifuge") then "-f" else "-k"

    command <<<
      set -x
      cp ~{nodes_dump} .
      cp ~{names_dump} . 
      rcf \
      ~{option} ~{input_file} \
      --nodespath . \
      --format ~{format} \
      --extra ~{output_type} \
      --outprefix ~{outprefix} \
      --controls ~{controls_number} \
      ~{if defined(taxid) then "--exclude" else ""}  ~{taxid}
    >>>

    output {
      Array[File] outputs = glob("${outprefix}*")
    }
    
    runtime {
      docker: docker
      memory: memory
    }
    
    
    meta {
      author: "Dieter Best"
      email: "Dieter.Best@cdph.ca.gov"
      description: "Display taxonomy analysis results from centrifuge or kraken"
    }
    
    parameter_meta {
      # inputs
      input_file: {description: "Classification result from centrifuge.", category: "required"}
      nodes_dump: {description: "Nodes database file for recentrifuge.", category: "required"}
      names_dump: {description: "Names database file for recentrifuge.", category: "required"}
      outprefix: {description: "Prefix for output files.", category: "required"}
      output_type: {description: "type of extra output to be generated, and can be one of ['FULL', 'CSV', 'MULTICSV', 'TSV', 'DYNOMICS']", category: "required"}
      controls_number: {description: "Number of first samples will be treated as negative controls; default is no controls", category: "optional"}
      taxid: {description: "Taxid to be excluded.", category: "optional"}
      format: {description: "Format of the output files from a generic classifier included with the option -g. It is a string like 'TYP:csv,TID:1,LEN:3,SCO:6,UNC:0' where valid file TYPes are csv/tsv/ssv, and the rest of fields indicate the number of column used (starting in 1) for the TaxIDs assigned, the LENgth of the read, the SCOre given to the assignment, and the taxid code used for UNClassified read", category: "advanced"}
      memory: {description: "The amount of memory available to the job.", category: "advanced"}
      docker: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}
      
      # outputs
    }
}
