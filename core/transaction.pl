:- module(transaction, [
              % database.pl
              query_context_transaction_objects/2,
              run_transaction/2,
              run_transactions/2,
              with_transaction/3,

              % descriptor.pl
              open_read_write_obj/2,
              open_read_write_obj/4,
              open_descriptor/2,
              open_descriptor/3,
              open_descriptor/5,
              collection_descriptor_transaction_object/3,
              graph_descriptor_transaction_objects_read_write_object/3,
              instance_graph_descriptor_transaction_object/3,
              read_write_obj_reader/2,
              read_write_obj_builder/2,
              filter_read_write_objects/3,
              make_branch_descriptor/5,
              make_branch_descriptor/4,
              make_branch_descriptor/3,
              read_write_object_to_name/2,
              transactions_to_map/2,

              % validate.pl
              transaction_objects_to_validation_objects/2,
              commit_validation_objects/1,
              validate_validation_objects/2,
              turtle_schema_transaction/4,

              % layer_entity.pl
              has_layer/2,
              layer_id_uri/3,
              insert_layer_object/3,

              % ref_entity.pl
              has_branch/2,
              branch_name_uri/3,
              branch_base_uri/3,
              branch_head_commit/3,
              commit_id_uri/3,
              commit_to_metadata/5,
              commit_to_parent/3,
              graph_for_commit/5,
              layer_uri_for_graph/3,
              insert_branch_object/4,
              insert_base_commit_object/3,
              insert_base_commit_object/4,
              insert_base_commit_object/5,
              insert_child_commit_object/4,
              insert_child_commit_object/5,
              insert_child_commit_object/6,
              insert_commit_object_on_branch/4,
              insert_commit_object_on_branch/5,
              insert_commit_object_on_branch/6,
              link_commit_object_to_branch/3,
              insert_graph_object/7,

              % repo_entity.pl
              has_repository/2,
              has_local_repository/2,
              has_remote_repository/2,
              repository_name_uri/3,
              repository_type/3,
              repository_head/3,
              repository_remote_url/3,

              insert_local_repository/3,
              insert_local_repository/4,
              insert_remote_repository/4,
              insert_remote_repository/5,

              update_repository_head/3,
              update_repository_remote_url/3
          ]).

:- use_module(transaction/database).
:- use_module(transaction/descriptor).
:- use_module(transaction/validate).
:- use_module(transaction/layer_entity).
:- use_module(transaction/ref_entity).
:- use_module(transaction/repo_entity).