$(document).ready(function() {
    var data = {
	"operators": {
	    "start": {
		"top": 20,
		"left": 20,
		"properties": {
		    "title": "Start",
		    "inputs": {},
		    "outputs": {
			"output": {
			    "label": "Output"
			}
		    }
		}
	    },
	    "concurrent": {
		"top": 160,
		"left": 140,
		"properties": {
		    "title": "Concurrent",
		    "inputs": {
			"input": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Step 1"
			},
			"output_2": {
			    "label": "Step 2"
			}
		    }
		}
	    },
	    "created_task_0": {
		"top": 40,
		"left": 420,
		"properties": {
		    "title": "Task 3",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Output"
			}
		    }
		}
	    },
	    "created_concurrent_1": {
		"top": 240,
		"left": 380,
		"properties": {
		    "title": "Concurrent 4",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Step 2"
			},
			"output_2": {
			    "label": "Step 2"
			}
		    }
		}
	    },
	    "created_condition_2": {
		"top": 160,
		"left": 580,
		"properties": {
		    "title": "Condition 5",
		    "inputs": {
			"input_1": {
			    "label": "If"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Condition"
			},
			"output_2": {
			    "label": "Then"
			},
			"output_3": {
			    "label": "Else"
			}
		    }
		}
	    },
	    "created_task_3": {
		"top": 380,
		"left": 600,
		"properties": {
		    "title": "Task 6",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Output"
			}
		    }
		}
	    },
	    "created_task_4": {
		"top": 120,
		"left": 820,
		"properties": {
		    "title": "Task 7",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Output"
			}
		    }
		}
	    },
	    "created_task_5": {
		"top": 220,
		"left": 820,
		"properties": {
		    "title": "Task 8",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Output"
			}
		    }
		}
	    },
	    "created_task_6": {
		"top": 320,
		"left": 820,
		"properties": {
		    "title": "Task 9",
		    "inputs": {
			"input_1": {
			    "label": "Input"
			}
		    },
		    "outputs": {
			"output_1": {
			    "label": "Output"
			}
		    }
		}
	    }
	},
	"links": {
	    "0": {
		"fromOperator": "concurrent",
		"fromConnector": "output_1",
		"fromSubConnector": 0,
		"toOperator": "created_task_0",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "1": {
		"fromOperator": "concurrent",
		"fromConnector": "output_2",
		"fromSubConnector": 0,
		    "toOperator": "created_concurrent_1",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "2": {
		"fromOperator": "created_concurrent_1",
		"fromConnector": "output_1",
		"fromSubConnector": 0,
		"toOperator": "created_condition_2",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "3": {
		"fromOperator": "created_concurrent_1",
		"fromConnector": "output_2",
		"fromSubConnector": 0,
		"toOperator": "created_task_3",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "4": {
		"fromOperator": "created_condition_2",
		"fromConnector": "output_3",
		"fromSubConnector": 0,
		"toOperator": "created_task_6",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "5": {
		"fromOperator": "created_condition_2",
		"fromConnector": "output_2",
		"fromSubConnector": 0,
		"toOperator": "created_task_5",
		"toConnector": "input_1",
		"toSubConnector": 0
		},
	    "6": {
		"fromOperator": "created_condition_2",
		"fromConnector": "output_1",
		"fromSubConnector": 0,
		"toOperator": "created_task_4",
		"toConnector": "input_1",
		"toSubConnector": 0
	    },
	    "link_1": {
		"fromOperator": "start",
		"fromConnector": "output",
		"toOperator": "concurrent",
		"toConnector": "input"
	    }
	}
    };
		  
    // Apply the plugin on a standard, empty div...
    console.log('test');
    var $flowchart = $('#sequence_flowchart');
    $flowchart.flowchart({ 'data' : data, 'defaultLinkColor': 'Green' });

    console.log('test2');
    var operatorI = 0;
    $flowchart.siblings('.create_concurrent').click(function() {
	var operatorId = 'created_concurrent_' + operatorI;
	var operatorData = {
	    top: 60,
	    left: 500,
	    properties: {
		title: 'Concurrent ' + (operatorI + 3),
		inputs: {
		    input_1: {
			label: 'Input',
		    }
		},
		outputs: {
		    output_1: {
			label: 'Step 2',
		    },
		    output_2: {
		        label: 'Step 2',
		    }
		    
		}
	    }
	};

	operatorI++;

	$flowchart.flowchart('createOperator', operatorId, operatorData);
    });

        $flowchart.siblings('.create_task').click(function() {
	var operatorId = 'created_task_' + operatorI;
	var operatorData = {
	    top: 60,
	    left: 500,
	    properties: {
		title: 'Task ' + (operatorI + 3),
		inputs: {
		    input_1: {
			label: 'Input',
		    }
		},
		outputs: {
		    output_1: {
			label: 'Output',
		    }
		    
		}
	    }
	};

	operatorI++;

	$flowchart.flowchart('createOperator', operatorId, operatorData);
    });

    
    $flowchart.siblings('.create_condition').click(function() {
	var operatorId = 'created_condition_' + operatorI;
	var operatorData = {
	    top: 60,
	    left: 500,
	    properties: {
		title: 'Condition ' + (operatorI + 3),
		inputs: {
		    input_1: {
			label: 'If',
		    }
		},
		outputs: {
		    output_1: {
			label: 'Condition',
		    },
		    output_2: {
			label: 'Then',
		    },
		    output_3: {
			label: 'Else',
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
