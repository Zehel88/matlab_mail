function e_mail(varargin)
% e_mail - Послать письмо по электронной почте

if nargin==0

    
%   Main form
    h=figure('MenuBar','None',...
        'Name','Отправить письмо',...
        'Position',[520 550 370 250],...
        'Tag','sendform');
    
%  
    MM=uicontrol('Parent',h,'Style','Checkbox',...
        'Position',[350 210 15 23],'BackgroundColor',[0.8 0.8 0.8],'Tag','cb');

    
%     edit 4 message
    uicontrol('Parent', h, 'Style', 'edit','String','',...
        'Position',[5 5 350 168],...
        'Max',2,'HorizontalAlignment','left',...
        'Tag','eMessage','FontSize',10);
%     to: label
    uicontrol('Parent', h, 'Style', 'text','String','',...
        'Position',[5 184 52 17],...
        'String','Кому:',...
        'FontSize',10,'BackgroundColor',[0.8 0.8 0.8]);
    
%     from: label
    uicontrol('Parent', h, 'Style', 'text','String','',...
        'Position',[5 216 52 17],...
        'String','От:',...
        'FontSize',10,'BackgroundColor',[0.8 0.8 0.8]);
%     from: label login
    uicontrol('Parent', h, 'Style', 'text','String','Логин',...
        'Position',[100 230 52 17],...
        'FontSize',10,'BackgroundColor',[0.8 0.8 0.8]);
%     from: label pass
    uicontrol('Parent', h, 'Style', 'text','String','Пароль',...
        'Position',[250 230 52 17],...
        'FontSize',10,'BackgroundColor',[0.8 0.8 0.8]);
    
%  to : edit
      uicontrol('Parent', h, 'Style', 'edit','String','',...
        'Position',[50 180 201 22],...
        'Tag','eTo');
%  from : edit login
      L=uicontrol('Parent', h, 'Style', 'edit','String','',...
        'Position',[50 210 150 22],...
        'Tag','eFromLogin');
%  from : edit pass
      P=uicontrol('Parent', h, 'Style', 'edit','String','',...
        'Position',[200 210 150 22],...
        'Tag','eFromPass');
    
%     send button
    uicontrol('Parent', h, 'Style', 'pushbutton','String','Отправить',...
        'Position',[255 180 101 23],...
        'Callback',{@btn_Send,h});
    
    if exist('MyMail.mat')==0
        set(MM,'Value',0);
    else
        load('MyMail.mat');
        set(L,'String',MyMail.Login);
        set(P,'String',MyMail.Pass);
        set(MM,'Value',1);
    end

elseif nargin==4
    
    Message=varargin{1};
    setpref('Internet','E_mail',varargin{3});
    
    if ~isempty(findstr(varargin{3},'@yandex.')) || ~isempty(findstr(varargin{3},'@ya.'))
        setpref('Internet','SMTP_Server','smtp.yandex.com');
    elseif ~isempty(findstr(varargin{3},'@gmail.'))
        setpref('Internet','SMTP_Server','smtp.gmail.com');
    elseif ~isempty(findstr(varargin{3},'@mail.'))
        setpref('Internet','SMTP_Server','smtp.mail.com');
    end
    
    setpref('Internet','SMTP_Username',varargin{3});
    setpref('Internet','SMTP_Password',varargin{4});
    
    
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    
    M='';
    for i=1:numel(Message(:,1))
        M=[M Message(i,:) 10];
    end
    sendmail(varargin{2},'',M);
end

function btn_Send(hObject, eventdata, handles)
try
h=guihandles(handles);
To=get(h.eTo,'String');
Login=get(h.eFromLogin,'String');
Pass=get(h.eFromPass,'String');
Message=get(h.eMessage,'String');
if get(h.cb,'Value')==1
    MyMail.Login=Login;
    MyMail.Pass=Pass;
    save('MyMail.mat','MyMail');
end
    setpref('Internet','E_mail',Login);
    
    if ~isempty(findstr(Login,'@yandex.')) || ~isempty(findstr(Login,'@ya.'))
        setpref('Internet','SMTP_Server','smtp.yandex.com');
    elseif ~isempty(findstr(Login,'@gmail.'))
        setpref('Internet','SMTP_Server','smtp.gmail.com');
    elseif ~isempty(findstr(Login,'@mail.'))
        setpref('Internet','SMTP_Server','smtp.mail.com');
    end
    
    setpref('Internet','SMTP_Username',Login);
    setpref('Internet','SMTP_Password',Pass);
    
    
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    
    M='';
    for i=1:numel(Message(:,1))
        M=[M Message(i,:) 10];
    end
    sendmail(To,'From Matlab',M);
catch
    errordlg({'Произошла ошибка!','Проверьте адреса почты отправителя или получателя.'})
end