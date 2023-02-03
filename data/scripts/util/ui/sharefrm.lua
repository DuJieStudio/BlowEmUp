hGlobal.UI.InitShareWindow = function(mode)
    local tInitEventName = {
        "LocalEvent_ShareWindow",
        "Show",
        "Close"
    }
    if mode ~= "include" then
        print("返回分享窗口事件表")
        return tInitEventName
    end

    local _frm, _parent, _childUI = nil, nil, nil
    local _img_path = nil
    local _old_screen_mode = nil
    local _old_can_spin_screen = nil

    local param = {
        btn_share = {
            space = 235,
            pos = {
                x = 0,
                y = -560
            },
            size = {
                w = 220,
                h = 80
            }
        }
    }

    local _CODE_CreateFrm = hApi.DoNothing
    local _CODE_ClearFunc = hApi.DoNothing
    local _CODE_DynamicAddShareImage = hApi.DoNothing
    local _CODE_DynamicRemoveShareImage = hApi.DoNothing

    _CODE_ClearFunc = function(is_reload_after_spin_screen)
        _CODE_DynamicRemoveShareImage()

        if hGlobal.UI.ShareWindow then
            hGlobal.UI.ShareWindow:del()
            hGlobal.UI.ShareWindow = nil
        end
        _frm, _parent, _childUI = nil, nil, nil
        _img_path = nil

        if not is_reload_after_spin_screen then
            hGlobal.event:listen("LocalEvent_refreshafterSpinScreen", "ShareWindow", nil)

            -- 横竖屏还原
            -- 不可旋转
            if _old_can_spin_screen and g_canSpinScreen ~= _old_can_spin_screen then
                g_canSpinScreen = _old_can_spin_screen
            end
            -- 锁竖屏
            if _old_screen_mode and g_CurScreenMode ~= _old_screen_mode then
                g_CurScreenMode = _old_screen_mode
                hApi.ChangeScreenMode()
            end
        end
    end

    _CODE_DynamicAddShareImage = function()
        local _frm = hGlobal.UI.ShareWindow
        if _frm then
            local _childUI = _frm.childUI

            local texture = CCTextureCache:sharedTextureCache():textureForKey(_img_path)
            if (not texture) then
                texture = CCTextureCache:sharedTextureCache():addImage(_img_path)
                print("新加载分享图片成功")
            else
                print("分享图片已存在，无需加载")
            end
            -- print(tostring(texture))
            local tSize = texture:getContentSize()
            print(string.format("尺寸: (w: %s , h: %s)", tostring(tSize.width), tostring(tSize.height)))
            local pSprite = CCSprite:createWithTexture(texture, CCRectMake(0, 0, tSize.width, tSize.height))
            pSprite:setPosition(32, 0)
            pSprite:setAnchorPoint(ccp(0.5, 0.5))
            pSprite:setScale(1)
            -- pSprite:setScaleX((hVar.SCREEN.w - iPhoneX_WIDTH * 2) / tSize.width)
            -- pSprite:setScaleY(hVar.SCREEN.h / tSize.height)
            _childUI["img_share"].data.pSprite = pSprite
            _childUI["img_share"].handle._n:addChild(pSprite)
        end
    end

    _CODE_DynamicRemoveShareImage = function()
        local _frm = hGlobal.UI.ShareWindow
        if _frm then
            local _childUI = _frm.childUI

            _childUI["img_share"].handle._n:removeChild(_childUI["img_share"].data.pSprite, true)

            local tex = CCTextureCache:sharedTextureCache():textureForKey(_img_path)
            if tex then
                CCTextureCache:sharedTextureCache():removeTexture(tex)
                print("释放分享大图资源")
            else
                print("分享大图不存在，无需释放")
            end
        end
    end

    _CODE_CreateFrm = function(imgPath, is_reload_after_spin_screen)
        _img_path = imgPath

        hGlobal.UI.ShareWindow = hUI.frame:new({
            -- model = "misc/mask.png",
            x = hVar.SCREEN.w / 2,
            y = hVar.SCREEN.h / 2,
            w = 0,
            h = 0,
            dragable = 2,
            bgAlpha = 0,
            bgMode = "tile",
            autoactive = 0,
            border = 0,
            background = -1,
            -- align = "MT",
            z = 500000 -- FIXME: 测试用参数 2022-12-27
        })

        _frm = hGlobal.UI.ShareWindow
        _parent = _frm.handle._n
        _childUI = _frm.childUI

        _childUI["img_bg"] = hUI.image:new({
            parent = _parent,
            model = "UI:zhezhao",
            x = 0,
            y = 0,
            w = hVar.SCREEN.w,
            h = hVar.SCREEN.h,
            background = 0
        })

        -- 提示文字title
        -- _childUI["lbl_title"] = hUI.label:new({
        --     parent = _parent,
        --     x = 0,
        --     y = hVar.SCREEN.h / 2 - 90,
        --     text = "分 享",
        --     size = 56,
        --     width = _frm.data.w,
        --     font = hVar.FONTC,
        --     align = "MT",
        --     border = 1,
        --     z = 2
        -- })

        _childUI["img_share"] = hUI.image:new({
            parent = _parent,
            model = "UI:zhezhao",
            x = 0,
            y = 92,
            background = 0
        })
        -- _childUI["img_share"].handle.s:setOpacity(0) -- 为了挂载动态图

        _childUI["btn_close"] = hUI.button:new({
            parent = _parent,
            dragbox = _childUI["dragBox"],
            model = "misc/skillup/btn_close.png",
            x = hVar.SCREEN.w / 2 - 60,
            y = 640 - 60,
            scaleT = 0.95,
            z = 2,
            code = function()
                _CODE_ClearFunc()
            end
        })

        _childUI["btn_share_wechat"] = hUI.button:new({
            parent = _parent,
            model = "misc/share/bg_btn_share.png",
            dragbox = _childUI["dragBox"],
            font = hVar.FONTC,
            border = 1,
            label = {
                text = "分享到微信",
                size = 28,
                y = 4,
                height = 60,
                font = hVar.FONTC
            },
            scaleT = 0.95,
            x = -param.btn_share.space,
            y = param.btn_share.pos.y,
            w = param.btn_share.size.w,
            h = param.btn_share.size.h,
            -- scale = 0.95,
            code = function(self)
                local ret = hApi.ShareSNS(hVar.ShareType.Wechat, imgPath)
                print("hApi.ShareSNS<Wechat> -> ret : " .. tostring(ret))

                -- _CODE_ClearFunc()
            end
        })

        _childUI["btn_share_wechat_friends"] = hUI.button:new({
            parent = _parent,
            model = "misc/share/bg_btn_share.png",
            dragbox = _childUI["dragBox"],
            font = hVar.FONTC,
            border = 1,
            label = {
                text = "分享到朋友圈",
                size = 28,
                y = 4,
                height = 60,
                font = hVar.FONTC
            },
            scaleT = 0.95,
            x = 0,
            y = param.btn_share.pos.y,
            w = param.btn_share.size.w,
            h = param.btn_share.size.h,
            -- scale = 0.95,
            code = function(self)
                local ret = hApi.ShareSNS(hVar.ShareType.WechatFriends, imgPath)
                print("hApi.ShareSNS<WechatFriends> -> ret : " .. tostring(ret))

                -- _CODE_ClearFunc()
            end
        })

        _childUI["btn_share_qq"] = hUI.button:new({
            parent = _parent,
            model = "misc/share/bg_btn_share.png",
            dragbox = _childUI["dragBox"],
            font = hVar.FONTC,
            border = 1,
            label = {
                text = "分享到QQ",
                size = 28,
                y = 4,
                height = 60,
                font = hVar.FONTC
            },
            scaleT = 0.95,
            x = param.btn_share.space,
            y = param.btn_share.pos.y,
            w = param.btn_share.size.w,
            h = param.btn_share.size.h,
            -- scale = 0.95,
            code = function(self)
                local ret = hApi.ShareSNS(hVar.ShareType.QQChat, imgPath)
                print("hApi.ShareSNS<QQChat> -> ret : " .. tostring(ret))

                -- _CODE_ClearFunc()
            end
        })

        _CODE_DynamicAddShareImage()

        _frm:active()
        _frm:show(1)

        if not is_reload_after_spin_screen then
            hGlobal.event:listen("LocalEvent_refreshafterSpinScreen", "ShareWindow", function()
                if _frm then
                    local param_img_path = _img_path
                    _CODE_ClearFunc(true)
                    _CODE_CreateFrm(param_img_path, true)
                end
            end)

            -- 锁竖屏
            _old_can_spin_screen = g_canSpinScreen
            _old_screen_mode = g_CurScreenMode
            print("_old_can_spin_screen:" .. tostring(_old_can_spin_screen))
            print("_old_screen_mode:" .. tostring(_old_screen_mode))
            if _old_can_spin_screen ~= 0 and _old_screen_mode ~= 2 then
                -- 不可旋转
                g_canSpinScreen = 0
                -- 锁竖屏
                g_CurScreenMode = 2
                hApi.ChangeScreenMode()
            end
        end
    end

    hGlobal.event:listen("LocalEvent_ShowShareWindow", "Show", function(imgPath)
        print("打开分享窗口 : imgPath:" .. tostring(imgPath))
        _CODE_ClearFunc()
        _CODE_CreateFrm(imgPath)
    end)

    hGlobal.event:listen("LocalEvent_CloseShareWindow", "Close", function()
        print("关闭分享窗口")
        _CODE_ClearFunc()
    end)

    print("分享窗口初始化完成")
end

hGlobal.UI.InitShareWindow("include")