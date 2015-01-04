function guimain    
    % Clear all vars
    clear;

    % Temporarily turn off old uitab and uitabgroup deprecated function warning.
    warning off MATLAB:uitab:DeprecatedFunction
    warning off MATLAB:uitabgroup:DeprecatedFunction

    dWidth = 1024;
    dHeight = 768;

    hFigure = figure('units','pixels',...
        'position',[1921 311 dWidth dHeight],...
        'menubar','none',...
        'name','Main',...
        'numbertitle','off',...
        'resize','off');
    handles = guihandles(hFigure);
    
    hSnake = Snake();
    handles.hSnake = hSnake;
    
    hAxes = axes(...
        'Parent', hFigure, ...
        'Units', 'normalized', ...
        'HandleVisibility', 'callback', ...
        'Visible', 'off', ...
        'Position', [0.11, 0.13, 0.80, 0.67]);
    handles.hAxes = hAxes;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String','Selected file:', ...
        'Position', [10, 740, 120, 20], ...
        'HorizontalAlignment', 'right');

    txtFilename = uicontrol('Style', 'text', ...
        'Parent', hFigure, ...
        'Position', [140 740 200 20], ...
        'String', 'No file selected', ...
        'HorizontalAlignment', 'left');
    txtFilenameUpdater = WindowUpdater(txtFilename);
    handles.txtFilenameUpdater = txtFilenameUpdater;

    uicontrol('Style', 'pushbutton', ...
        'Parent', hFigure, ...
        'Position', [330 740 120 20], ...
        'Callback', @selectFile, ...
        'String', 'Select image file');
    
    hStartButton = uicontrol('Style', 'pushbutton', ...
        'Parent', hFigure, ...
        'Position', [790 45 120 20], ...
        'Callback', @start, ...
        'Enable', 'off', ...
        'String', 'Start');
    handles.hStartButton = hStartButton;
    
    hDeleteSnakeButton = uicontrol('Style', 'pushbutton', ...
        'Parent', hFigure, ...
        'Position', [790 25 120 20], ...
        'Callback', @deleteSnake, ...
        'Enable', 'off', ...
        'String', 'Delete snake');
    handles.hDeleteSnakeButton = hDeleteSnakeButton;
    
    hDoubleSnakeButton = uicontrol('Style', 'pushbutton', ...
        'Parent', hFigure, ...
        'Position', [660 25 120 20], ...
        'Callback', @doubleSnakePoints, ...
        'Enable', 'off', ...
        'String', 'Double snake points');
    handles.hDoubleSnakeButton = hDoubleSnakeButton;
    
    hHalfSnakeButton = uicontrol('Style', 'pushbutton', ...
        'Parent', hFigure, ...
        'Position', [530 25 120 20], ...
        'Callback', @halfSnakePoints, ...
        'Enable', 'off', ...
        'String', 'Half snake points');
    handles.hHalfSnakeButton = hHalfSnakeButton;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Scale factor:', ...
        'Position', [10, 700, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    
    % General scale factor
    
    hScaleValue = uicontrol('Style', 'edit', ...
        'Position', [150, 700, 120, 20], ...
        'String', hSnake.scale, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hScaleValue', 'String', hSnake, 'scale'});
    handles.hScaleValue = get(hScaleValue, 'String');
    hScaleValueUpdater = WindowUpdater(hScaleValue);
    handles.hScaleValueUpdater = hScaleValueUpdater;
    
    
    % Elasticity, alpha-value
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Elasticity factor:', ...
        'Position', [10, 670, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    hElasticityValue = uicontrol('Style', 'edit', ...
        'Position', [150, 670, 120, 20], ...
        'String', hSnake.elasticity, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hElasticityValue', 'String', hSnake, 'elasticity'});
    handles.hElasticityValue = get(hElasticityValue, 'String');
    hElasticityValueUpdater = WindowUpdater(hElasticityValue);
    handles.hElasticityValueUpdater = hElasticityValueUpdater;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Elasticity (alpha):', ...
        'Position', [10, 650, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    hAlphaValue = uicontrol('Style', 'edit', ...
        'Position', [150, 650, 120, 20], ...
        'String', hSnake.alpha, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hAlphaValue', 'String', hSnake, 'alpha'});
    handles.hAlphaValue = get(hAlphaValue, 'String');
    hAlphaValueUpdater = WindowUpdater(hAlphaValue);
    handles.hAlphaValueUpdater = hAlphaValueUpdater;

    
    % Curvature, beta-value
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Curvature factor:', ...
        'Position', [10, 620, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    hCurvatureValue = uicontrol('Style', 'edit', ...
        'Position', [150, 620, 120, 20], ...
        'String', hSnake.curvature, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hCurvatureValue', 'String', hSnake, 'curvature'});
    handles.hCurvatureValue = get(hCurvatureValue, 'String');
    hCurvatureValueUpdater = WindowUpdater(hCurvatureValue);
    handles.hCurvatureValueUpdater = hCurvatureValueUpdater;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Curvature (beta):', ...
        'Position', [10, 600, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    hBetaValue = uicontrol('Style', 'edit', ...
        'Position', [150, 600, 120, 20], ...
        'String', hSnake.beta, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hBetaValue', 'String', hSnake, 'beta'});
    handles.hBetaValue = get(hBetaValue, 'String');
    hBetaValueUpdater = WindowUpdater(hBetaValue);
    handles.hBetaValueUpdater = hBetaValueUpdater;
    
    % Image force, gamma-value
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Image force factor:', ...
        'Position', [10, 570, 120, 20], ...
        'HorizontalAlignment', 'left');
    
    hImageForceValue = uicontrol('Style', 'edit', ...
        'Position', [150, 570, 120, 20], ...
        'String', hSnake.imageforce, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hImageForceValue', 'String', hSnake, 'imageforce'});
    handles.hImageForceValue = get(hImageForceValue, 'String');
    hImageForceValueUpdater = WindowUpdater(hImageForceValue);
    handles.hImageForceValueUpdater = hImageForceValueUpdater;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Image force (gamma):', ...
        'Position', [10, 550, 160, 20], ...
        'HorizontalAlignment', 'left');
    
    hGammaValue = uicontrol('Style', 'edit', ...
        'Position', [150, 550, 120, 20], ...
        'String', hSnake.gamma, ...
        'Parent', hFigure, ...
        'Callback', {@setPropertyValue, 'hGammaValue', 'String', hSnake, 'gamma'});
    handles.hGammaValue = get(hGammaValue, 'String');
    hGammaValueUpdater = WindowUpdater(hGammaValue);
    handles.hGammaValueUpdater = hGammaValueUpdater;
    
    uicontrol('Style','text', ...
        'Parent', hFigure, ...
        'String', 'Image method:', ...
        'Position', [10, 500, 160, 20], ...
        'HorizontalAlignment', 'left');
    
    hImageMethod = uicontrol('Style', 'popupmenu', ...
        'Parent', hFigure, ...
        'Position', [150 492 120 30], ...
        'String', {'Grayscale', 'Gaussian', 'Edges'}, ...
        'Callback', @changeImageMethod);
    handles.hImageMethod = hImageMethod;
    
    % Update GUI
    guidata(hFigure, handles);
    set(hFigure,'Visible','on');
end

function selectFile(hObject, eventdata)
    handles = guidata(hObject);

    [filename, pathname] = uigetfile('*.jpg; *.png', 'Please select an image file to process..');
    if (isequal(filename, 0))
        disp('File could not be loaded');
        return;
    end
    
    fileString = [pathname, filename];
    handles.imagePath = fileString;
    
    img = imread(fileString);
    handles.imageRawOrig = img;
    
    % Convert to grays cale
    out_img = rgb2gray(img);
    handles.imageGrayScale = out_img;
    
    % Smoothed gaussian blurred image
    % Default: 13
    blurAmount = 13;
    alpha = 100 / (blurAmount * 5);
    maskSize = 16;
    filter = fspecial('gaussian', [maskSize maskSize], alpha); 
    out_img = imfilter(out_img, filter, 'replicate');
    handles.imageSmoothed = out_img;

    % Edge detection
    out_img = edge(out_img, 'canny');
    filter = fspecial('gaussian', size(out_img), 0.2); 
    out_img = imfilter(out_img, filter, 'replicate');
    handles.imageEdged = out_img;
    
    txtFilenameUpdater = handles.txtFilenameUpdater;
    txtFilenameUpdater.update(filename);
    
    % Get currently selected output method
    hImageMethod = handles.hImageMethod;
    imageMethod = get(hImageMethod, 'Value');
    
    switch imageMethod
        case 1
            hOutputImage = handles.imageGrayScale;
            hSourceImage = handles.imageGrayScale;
        case 2
            hOutputImage = handles.imageSmoothed;
            hSourceImage = handles.imageSmoothed;
        case 3
            hOutputImage = handles.imageEdged;
            hSourceImage = handles.imageEdged;
        otherwise
            hOutputImage = handles.imageGrayScale;
            hSourceImage = handles.imageGrayScale;
    end
    handles.hOutputImage = hOutputImage;
    handles.hSourceImage = hSourceImage;
    
    hImg = imshow(hOutputImage, 'Parent', gca);
    set(hImg, 'ButtonDownFcn',{@addSnakePoint});
    title('Image with selected rendering model', 'FontSize', 16);
    
    guidata(hObject, handles);
end

function start(hObject, eventdata)
    handles = guidata(hObject);
    
    % Number of runs
    nRuns = 1000;
    nUpdateRate = 20;
    
    hSnake = handles.hSnake;
    
    % Get file name
    fileString = handles.imagePath;
    fprintf('Starting to operate on %s\n', fileString);
    
    hSourceImage = handles.hSourceImage;
    hOutputImage = handles.hOutputImage;
    
    % Draw snake
    hSnake.draw(hSourceImage, hOutputImage);
    
    tic;
    for n = 1 : nRuns    
        if (~mod(n, nUpdateRate))
            pause(0.001);
            hSnake.update();
            hSnake.draw(hSourceImage, hOutputImage);
        end
    end
    toc;
end

function setPropertyValue(hObject, eventdata, objectvariable, objecttype, target, targetvariable)
    handles = guidata(hObject);
    
    value = get(hObject, objecttype); 
    
    updaterName = genvarname([objectvariable, 'Updater']);
    updater = handles.(updaterName);
    updater.update(value);
    
    varName = genvarname(objectvariable);
    handles.(varName) = str2num(value);
    
    if nargin == 6
        targetvar = target.(targetvariable);
        target.(targetvariable) = str2num(value);
        fprintf('Set "%s" of "%s" to "%s"\n', targetvariable, class(target), value);
    end
    
    fprintf('Set property "%s" to "%s"\n', objectvariable, value);
    
    guidata(hObject, handles);
end

function addSnakePoint(hObject, eventdata)
    handles = guidata(hObject);
    
    hSnake = handles.hSnake;
    hAxes = handles.hAxes;
    hDeleteSnakeButton = handles.hDeleteSnakeButton;
    hDoubleSnakeButton = handles.hDoubleSnakeButton;
    hHalfSnakeButton = handles.hHalfSnakeButton;
    hStartButton = handles.hStartButton;
    
    set(hDeleteSnakeButton, 'Enable', 'on');
    set(hDoubleSnakeButton, 'Enable', 'on');
    set(hHalfSnakeButton, 'Enable', 'on');
    set(hStartButton, 'Enable', 'on');
    
    coordinates = get(hAxes, 'CurrentPoint'); 
    coordinates = coordinates(1,1:2);
    message     = sprintf('x: %.1f , y: %.1f\n',coordinates (1) ,coordinates (2));
    fprintf(message);
    
    % Add snake point
    hSnake.addPoint(coordinates);
    handles.hSnake = hSnake;
    
    % Draw added point
    red = uint8([255 0 0]);  % [R G B]; class of red must match class of I
    markerInserter = vision.MarkerInserter('Shape','Circle','BorderColor','Custom','CustomBorderColor',red);
    
    if (islogical(handles.hOutputImage))
        rawImg = double(cat(3, handles.hOutputImage, handles.hOutputImage, handles.hOutputImage));
    else
        rawImg = repmat(handles.hOutputImage, [1 1 3]);
    end
    
    pointsSize = size(hSnake.points);
    nPoints = pointsSize(2);
    
    for n = 1 : nPoints
        currentPoint = hSnake.points(1, n);
        rawImg = step(markerInserter, rawImg, int32(currentPoint.position)); 
    end
    
    hProcessedImg = imshow(rawImg, 'parent', gca);
    set(hProcessedImg, 'ButtonDownFcn',{@addSnakePoint});
    
    guidata(hAxes, handles);
end

function deleteSnake(hObject, eventdata)
    handles = guidata(hObject);
    
    rawImage = handles.imageRawOrig;
    hSnake = handles.hSnake;
    hDeleteSnakeButton = handles.hDeleteSnakeButton;
    hDoubleSnakeButton = handles.hDoubleSnakeButton;
    hHalfSnakeButton = handles.hHalfSnakeButton;
    hStartButton = handles.hStartButton;
    hAxes = handles.hAxes;
    hOutputImage = handles.hOutputImage;
    
    % Delete points
    hSnake.deleteAllPoints();
    set(hDeleteSnakeButton, 'Enable', 'off');
    set(hDoubleSnakeButton, 'Enable', 'off');
    set(hHalfSnakeButton, 'Enable', 'off');
    set(hStartButton, 'Enable', 'off');
    
    % Redraw image
    hImg = imshow(hOutputImage, 'Parent', hAxes);
    set(hImg, 'ButtonDownFcn',{@addSnakePoint});
    
    guidata(hObject, handles);
end

function doubleSnakePoints(hObject, eventdata)
    handles = guidata(hObject);
    
    hSnake = handles.hSnake;
    hSnake.doublePoints();
    
    hSourceImage = handles.hSourceImage;
    hOutputImage = handles.hOutputImage;

    hSnake.draw(hSourceImage, hOutputImage);
    
    guidata(hObject, handles);
end

function halfSnakePoints(hObject, eventdata)
    handles = guidata(hObject);
    
    hSnake = handles.hSnake;
    hSnake.halfPoints();
    
    hSourceImage = handles.hSourceImage;
    hOutputImage = handles.hOutputImage;
    
    hSnake.draw(hSourceImage, hOutputImage);
    
    guidata(hObject, handles);
end

function changeImageMethod(hObject, eventdata)
    handles = guidata(hObject);
    
    hSnake = handles.hSnake;
    value = get(hObject, 'Value');
    
    switch value
        case 1
            hOutputImage = handles.imageGrayScale;
            hSourceImage = handles.imageGrayScale;
        case 2
            hOutputImage = handles.imageSmoothed;
            hSourceImage = handles.imageSmoothed;
        case 3
            hOutputImage = handles.imageEdged;
            hSourceImage = handles.imageEdged;
        otherwise
            hOutputImage = handles.imageGrayScale;
            hSourceImage = handles.imageGrayScale;
    end
    
    hImg = hSnake.draw(hSourceImage, hOutputImage);
    set(hImg, 'ButtonDownFcn',{@addSnakePoint});
    title('Image with selected rendering model', 'FontSize', 16);
    
    handles.hSourceImage = hSourceImage;
    handles.hOutputImage = hOutputImage;
    
    guidata(hObject, handles);
end