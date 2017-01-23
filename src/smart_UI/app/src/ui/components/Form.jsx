var React = require('react');

var Button = require('react-lightning-design-system').Button;

module.exports = React.createClass({
	displayName: 'Form',

	isButtonDisabled: function(){
		var buttonDisabled = false;
        var valueString;

        this.props.fields.map(field =>{
            valueString=field.value.toString().trim();
            if(field.isValid && !field.isValid(field.value))
                buttonDisabled=true;
            if(field.required && valueString==''){
                buttonDisabled=true;
            }

        })

        return buttonDisabled;
    },
    render: function() {
        return (
    		<div className = {this.props.class}>
    			<ul>
					{this.props.fields.map((item)=>(
						<li>
						{item.component}
						</li>
					))}
				</ul>

    			<div className="slds-text-align--right slds-p-top--large icon-button-group">
                        <Button type='neutral' icon='close' iconAlign='left' className="icon-button"
                                onClick={()=>this.props.onCancel()}> {AppManager.getLabel('PP_BTN_CANCEL') || 'Cancel'}</Button>
                        <Button type='brand' icon='check' iconAlign='left' className="icon-button"
                                onClick={()=>this.props.onSave()} disabled={this.isButtonDisabled()}> {AppManager.getLabel('PC_BTN_SAVE') || 'Save'}</Button>
                    </div>
    		</div>
    	);
    }
});