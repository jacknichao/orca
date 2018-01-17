classdef NNPOM < Algorithm
    %NNPOM Neural Network based on Proportional Odd Model (NNPOM). This 
    % class implements a neural network model for ordinal regression. The
    % model has one hidden layer with hiddenN neurons and one outputlayer
    % with only one neuron but as many threshold as the number of classes
    % minus one. The standard POM model is applied in this neuron to have
    % probabilistic outputs. The learning is based on iRProp+ algorithm and
    % the implementation provided by Roberto Calandra in his toolbox Rprop 
    % Toolbox for {MATLAB}:
    % http://www.ias.informatik.tu-darmstadt.de/Research/RpropToolbox
    % The model is adjusted by minimizing cross entropy. A regularization 
    % parameter "lambda" is included based on L2, and the number of 
    % iterations is specified by the "iter" parameter.
    %   NNPOM methods:
    %      runAlgorithm               - runs the corresponding algorithm,
    %                                   fitting the model and testing it 
    %                                   in a dataset.
    %      fit                        - Fits a model from training data
    %      predict                    - Performs label prediction
    %
    %   NNPOM properties:
    %      epsilonInit                - Range for initializing the weights.
    %      parameters.hiddenN         - Number of hidden neurons of the
    %                                   model.
    %      parameters.iter            - Number of iterations for iRProp+
    %                                   algorithm.
    %      parameters.lambda          - Regularization parameter.
    %
    %   References:
    %     [1] P. McCullagh, Regression models for ordinal data,  Journal of
    %         the Royal Statistical Society. Series B (Methodological), vol. 42,
    %         no. 2, pp. 109–142, 1980.
    %     [2] M. J. Mathieson, Ordinal models for neural networks, in Proc.
    %         3rd Int. Conf. Neural Netw. Capital Markets, 1996, pp. 
    %         523-536.
    %     [3] P.A. Gutiérrez, M. Pérez-Ortiz, J. Sánchez-Monedero,
    %         F. Fernández-Navarro and C. Hervás-Martínez
    %         Ordinal regression methods: survey and experimental study
    %         IEEE Transactions on Knowledge and Data Engineering, Vol. 28.
    %         Issue 1, 2016
    %         http://dx.doi.org/10.1109/TKDE.2015.2457911
    %
    %   This file is part of ORCA: https://github.com/ayrna/orca
    %   Original authors: Pedro Antonio Gutiérrez, María Pérez Ortiz, Javier Sánchez Monedero
    %   Citation: If you use this code, please cite the associated paper http://www.uco.es/grupos/ayrna/orreview
    %   Copyright:
    %       This software is released under the The GNU General Public License v3.0 licence
    %       available at http://www.gnu.org/licenses/gpl-3.0.html
    
    properties
        
        % Weights range
        epsilonInit = 0.5;
        
        parameters = struct('iter', 500,'hiddenN', 50,'lambda', 0.01);
    end
    
    
    methods
        
        
        function obj = NNPOM(varargin)
            %NNPOM constructs an object of the class NNPOM and sets its default
            %   characteristics
            %   obj = NNPOM('epsilonInit', 0.5) sets initialization of
            %   epsilon to 0.5
            obj.name = 'Neural Network based on Proportional Odd Model';
            obj.parseArgs(varargin);
            
        end  
        
        function [model, projectedTrain, predictedTrain] = fit( obj, train, parameters)
            %FIT trains the model for the NNPOM method with TRAIN data and
            %vector of parameters PARAMETERS. Return the learned model.
            
            % Aux variables
            X = train.patterns;
            y = train.targets;
            input_layer_size  = size(X,2);
            hidden_layer_size = parameters.hiddenN;
            num_labels = numel(unique(y));  
            m = size(X,1);
            
            % Recode y to Y using nominal coding
            Y = repmat(y,1,num_labels) == repmat((1:num_labels),m,1);
            
            % Hidden layer weigths (with bias)
            initial_Theta1 = obj.randInitializeWeights(input_layer_size+1, hidden_layer_size);
            % Output layer weigths (without bias, the biases will be the
            %                       Thresholds)
            initial_Theta2 = obj.randInitializeWeights(hidden_layer_size, 1);
            % Class thresholds parameters
            initial_Thresholds = obj.randInitializeWeights((num_labels-1),1);

            % Pack parameters
            initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:) ; initial_Thresholds(:)];      
            
            % Set regularization parameter
            lambda = parameters.lambda;
            
            % Create "short hand" for the cost function to be minimized
            costFunction = @(p) obj.nnPOMCostFunction(p, ...
                                               input_layer_size, ...
                                               hidden_layer_size, ...
                                               num_labels, X, Y, lambda);                                           
            % RProp options
            p.verbosity = 0;                    % Increase indent
            p.MaxIter   = parameters.iter;     	% Maximum number of iterations
            p.d_Obj     = -1;                   % Objective cost
            p.method    = 'IRprop+';            % Use IRprop- algorithm
            p.display   = 0;
            
            % Running RProp
            [nn_params,cost,exitflag,stats1] = rprop(costFunction,initial_nn_params,p);
            
%             options = optimoptions('fminunc','Algorithm','quasi-newton','SpecifyObjectiveGradient',true,'Diagnostics','on','Display','iter-detailed','UseParallel',true,'MaxIter', 1000,'CheckGradients',true);
%             [nn_params, cost, exitflag, output] = fminunc(costFunction, initial_nn_params, options);

            
            % Unpack the parameters
            [Theta1, Theta2, Thresholds_param] = obj.unpackParameters(nn_params,input_layer_size,hidden_layer_size,num_labels);
            model.Theta1=Theta1;
            model.Theta2=Theta2;
            model.Thresholds=obj.convertThresholds(Thresholds_param,num_labels);
            model.num_labels=num_labels;
            model.m = m;
            
            [projectedTrain, predictedTrain] = obj.predict(train.patterns, model);
            model.algorithm = 'NNPOM';
            model.parameters = parameters;
            
        end
       
        function [projected, predicted]= predict(obj,test,model)
            %PREDICT predicts labels of TEST patterns labels using MODEL.
            m = size(test,1);
            a1 = [ones(m, 1) test];
            z2 = a1*model.Theta1';
            a2 =  1.0 ./ (1.0 + exp(-z2));
            projected=a2*model.Theta2';
            
            z3=repmat(model.Thresholds,m,1)-repmat(projected,1,model.num_labels-1);
            a3T =  1.0 ./ (1.0 + exp(-z3));
            a3 = [a3T ones(m,1)];
            a3(:,2:end) = a3(:,2:end) - a3(:,1:(end-1));
            [M,predicted] = max(a3,[],2);            
        end
        
    end
    
    methods(Access = private)
        
        function [Theta1, Theta2, Thresholds_param] = unpackParameters(obj,nn_params,input_layer_size,hidden_layer_size,num_labels)
            % UNPACKPARAMETERS obtains Theta1, Theta2 and Thresholds_param
            % back from the whole array nn_params
            nTheta1 = hidden_layer_size * (input_layer_size + 1);
            Theta1 = reshape(nn_params(1:nTheta1), ...
                             hidden_layer_size, (input_layer_size + 1));
            nTheta2 = hidden_layer_size;
            Theta2 = reshape(nn_params((1+nTheta1):(nTheta1+nTheta2)), ...
                             1, (hidden_layer_size));
            Thresholds_param = reshape(nn_params((nTheta1+nTheta2+1):end), ...
                             (num_labels-1), 1);
        end
        
        function W = randInitializeWeights(obj, L_in, L_out)
            %RANDINITIALIZEWEIGHTS randomly initializes the weights of a layer with L_in
            %incoming connections and L_out outgoing connections
            W = rand(L_out, L_in)*2*obj.epsilonInit - obj.epsilonInit;
        end
        
        function Thresholds = convertThresholds(obj, Thresholds_param,num_labels)        
            % CONVERTTHRESHOLDS transforms thresholds to perform 
            % unconstrained optimization
            % Thresholds(1) = Thresholds_param(1)
            % Thresholds(2) = Thresholds_param(1) + Thresholds_param(1)^2
            % Thresholds(3) = Thresholds_param(1) + Thresholds_param(1)^2
            %               + Thresholds_param(2)^2
            % ...
            Thresholds_pquad=Thresholds_param.^2;
            Thresholds = sum(tril(ones(num_labels-1,num_labels-1)).*...
                repmat([Thresholds_param(1);Thresholds_pquad(2:end)],1,num_labels-1)',2);
            Thresholds = Thresholds';
        end
            
        function [J,grad] = nnPOMCostFunction(obj, nn_params, ...
                input_layer_size, ...
                hidden_layer_size, ...
                num_labels, ...
                X, Y, lambda)
            %NNPOMCOSTFUNCTION implements the cost function and obtains the
            %corresponding derivatives.
            
            % Unroll all the parameters
            [Theta1, Theta2, Thresholds_param] = unpackParameters(obj,...
                nn_params,input_layer_size,hidden_layer_size,num_labels);
            
            
            % Convert threhsolds
            Thresholds = obj.convertThresholds(Thresholds_param,num_labels);
            
            % Setup some useful variables
            m = size(X, 1);
                        
            % Neural Network model
            a1 = [ones(m, 1) X];
            z2 = a1*Theta1';
            a2 =  1.0 ./ (1.0 + exp(-z2));
            z3=repmat(Thresholds,m,1)-repmat(a2*Theta2',1,num_labels-1);
            a3T =  1.0 ./ (1.0 + exp(-z3));
            a3 = [a3T ones(m,1)];
            h = [a3(:,1) (a3(:,2:end) - a3(:,1:(end-1)))];
            
            % Final output
            out = h;
            
            % calculte penalty (regularización L2)
            p = sum(sum(Theta1(:, 2:end).^2, 2))+sum(sum(Theta2(:, 1:end).^2, 2));
            
            % MSE
            %J = sum(sum((out-Y).^2, 2))/(2*m) + lambda*p/(2*m);
            % Cross entropy
            J = sum(-log(out(Y==1)), 1)/m + lambda*p/(2*m);
            if nargout > 1
                % Cross entropy
                %out(out<0.00001)=0.00001;
                errorDer = zeros(size(Y));
                errorDer(Y~=0) = (-Y(Y~=0)./out(Y~=0));
                
                % MSE
                %errorDer=(out-Y);
                
                % Calculate sigmas
                fGradients = a3T.*(1-a3T);
                gGradients = errorDer.*[fGradients(:,1) (fGradients(:,2:end)-fGradients(:,1:(end-1))) -fGradients(:,end)];
                sigma3 = -sum(gGradients,2);
                sigma2 = (sigma3*Theta2).*a2.*(1-a2);
                
                % Accumulate gradients
                delta_1 = (sigma2'*a1);
                delta_2 = (sigma3'*a2);
                
                % calculate regularized gradient
                p1 = (lambda/m)*[zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];
                p2 = (lambda/m)*Theta2(:, 1:end);
                Theta1_grad = delta_1./m + p1;
                Theta2_grad = delta_2./m + p2;                
                
                % Treshold gradients
                ThreshGradMatrix=[triu(ones(num_labels-1)) ones(num_labels-1,1)].*repmat(sum(gGradients,1),num_labels-1,1);
                ThreshGradMatrix((num_labels+1):num_labels:end) = ThreshGradMatrix((num_labels+1):num_labels:end) + sum(errorDer(:,2:(num_labels-1)).*fGradients(:,1:(num_labels-2)));
                Threshold_grad=sum(ThreshGradMatrix,2)/m;
                Threshold_grad(2:end) = 2 * (Threshold_grad(2:end) .* Thresholds_param(2:end));
                               
                % Unroll gradients
                grad = [Theta1_grad(:) ; Theta2_grad(:); Threshold_grad(:)];
            end

        end
    end
end

