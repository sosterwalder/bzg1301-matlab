classdef WindowUpdater < handle
    properties(Access=private)
        formElement;
    end
    
    methods(Access=public)
        function this = WindowUpdater(formElement)
            this.formElement = formElement;
        end
        
        function update(this, strText)
            set(this.formElement, 'String', strText);
            drawnow();
        end
    end
end