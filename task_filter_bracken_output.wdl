version 1.0

#
# Filter out taxids from bracken classification output
#

task task_filter_bracken_output {
  input {
    File bracken_file
    Array[Int] taxid_exclude = []
    Array[Int] taxid_include = []
    String samplename
    String docker = "dbest/krakentools:v1.2"
    String memory = "10GB"
    Int disk_size = 100
  }

  String bracken_file_filtered = samplename + ".bracken.filtered.report"
  String bracken_file_filtered_error = samplename + ".bracken.filtered.error"
  
  command <<<
    set -ex
    NLINES=$(wc -l < ~{bracken_file})
    if [ -s ~{bracken_file} ] && [ "${NLINES}" -gt 1 ]
    then
    filter_bracken.out.py \
    --input-file ~{bracken_file} \
    --output ~{bracken_file_filtered} \
    ~{if length(taxid_exclude) > 0 then "--exclude" else ""} ~{sep="" taxid_exclude} \
    ~{if length(taxid_include) > 0 then "--include" else ""} ~{sep="" taxid_include}
    else
    echo "Bracken file file does not exist or is empty" > ~{bracken_file_filtered_error}
    fi
  >>>

  output {
    File? output_file = bracken_file_filtered
    File error_file = bracken_file_filtered_error
  }

  runtime {
    docker: docker
    memory: memory
    disks: "local-disk " + disk_size + " SSD"
  }

  meta {
    author: "Dieter Best"
    email: "Dieter.Best@cdph.ca.gov"
    description: "Filter out taxids from bracken classification output"
  }
  
  parameter_meta {
    # inputs
    bracken_file: {description: "Classification result from bracken.", category: "required"}
    taxid_exclude: {description: "List of taxids to be included or excluded. Can be empty list.", category: "required"}
    taxid_include: {description: "List of taxids to be included or excluded. Can be empty list.", category: "required"}
    samplename: {
      description:"The name of the sample being processed, used to generate output filenames.", category: "required"
    }
    docker: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}
    memory: {description: "The amount of memory available to the job.", category: "advanced"}
    
    # outputs
    output_file: {description: "Filtered bracken output file."}
    error_file: {description: "Output file with error messages."}
  }
}
