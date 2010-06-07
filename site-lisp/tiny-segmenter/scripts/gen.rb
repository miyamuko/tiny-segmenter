require "kconv"
require "tiny_segmenter"

TinySegmenter::Model.constants.sort.each do |const|
  model = eval("::TinySegmenter::Model::#{const}")
  next unless Hash === model
  print "(defparameter *#{const}*"
  print " (let ((h (make-hash-table :test #'equal :size #{model.size})))"
  print " (setf"
  model.each_with_index do |pair,i|
    print " (gethash \"#{pair[0].tosjis}\" h) #{pair[1]}"
  end
  print ")"
  print " h))"
  puts
end

