class GobstonesMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'gobstones',
        icon: {type: 'devicon', name: 'gobstones'},
        version: '1.4.1',
        extension: 'gbs',
        ace_mode: 'gobstones',
        graphic: true
    },
     test_framework: {
         name: 'stones-spec',
         test_extension: 'yml',
         template: <<xgobstones
check_head_position: true

examples:
 - title: '{{ test_template_sample_description }}'
   initial_board: |
     GBB/1.0
     size x y
     cell x y Negro 1
     cell x y Rojo 1
     head x y
   final_board: |
     GBB/1.0
     size x y
     cell x y Negro 1
     cell x y Rojo 0
     head x y
xgobstones
     }}
  end
end
