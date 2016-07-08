$(document).ready(function() {
    var data = {
	operators: {
	    start: {
		top: 20,
		left: 20,
		properties: {
		    title: 'Start',
		    inputs: {},
		    outputs: {
			output: {
			    label: 'Output',
			}
		    }
		}
	    },
	    concurrent: {
		top: 80,
		left: 100,
		properties: {
		    title: 'Concurrent',
		    inputs: {
			input: {
			    label: 'Input',
			}
		    },
		    outputs: {
			output_1: {
			    label: 'Step 1',
			},
			output_2: {
			    label: 'Step 2',
			},
		    }
		}
	    },
	},
	links: {
	    link_1: {
		fromOperator: 'start',
		fromConnector: 'output',
		toOperator: 'concurrent',
		toConnector: 'input',
	    },
	}
    };

    // Apply the plugin on a standard, empty div...
    console.log('test');
    var $flowchart = $('#sequence_flowchart');
    $flowchart.flowchart({ 'data' : data, 'defaultLinkColor': 'Green' });

    console.log('test2');
    var operatorI = 0;
    $flowchart.siblings('.create_operator').click(function() {
	var operatorId = 'created_operator_' + operatorI;
	var operatorData = {
	    top: 60,
	    left: 500,
	    properties: {
		title: 'Operator ' + (operatorI + 3),
		inputs: {
		    input_1: {
			label: 'Input 1',
		    }
		},
		outputs: {
		    output_1: {
			label: 'Output 1',
		    }
		}
	    }
	};

	operatorI++;

	$flowchart.flowchart('createOperator', operatorId, operatorData);
    });

    $flowchart.siblings('.delete_selected_button').click(function() {
	$flowchart.flowchart('deleteSelected');
    });

    $flowchart.siblings('.get_data').click(function() {
	var data = $flowchart.flowchart('getData');
	$('#flowchart_data').val(JSON.stringify(data, null, 2));
    });

    $flowchart.siblings('.set_data').click(function() {
	var data = JSON.parse($('#flowchart_data').val());
	$flowchart.flowchart('setData', data);
    });
});
