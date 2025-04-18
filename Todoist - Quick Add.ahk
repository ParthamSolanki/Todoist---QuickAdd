#Requires AutoHotkey v2.0

^Space:: {
    static myGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Quick Task")
    myGui.Destroy()

    myGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Quick Task")
    myGui.BackColor := "1A1A1A"
    myGui.SetFont("s14 cF0F0F0", "Segoe UI")
    myGui.MarginX := 15
    myGui.MarginY := 15

    taskInput := myGui.Add("Edit", "vTaskInput w400 h40 Background2D2D2D cWhite -E0x200")
    taskInput.OnEvent("Change", AutocompleteTrigger)
    taskInput.Focus()

    suggestionBox := myGui.Add("ListBox", "vSuggestionBox w400 h0 Background252525 cWhite Hidden -HScroll")
    suggestionBox.SetFont("s12", "Segoe UI")
    suggestionBox.OnEvent("DoubleClick", AutocompleteSelect)

    DllCall("dwmapi\DwmSetWindowAttribute", "ptr", myGui.Hwnd, "int", 33, "int*", 2, "int", 4)

    btnAdd := myGui.Add("Button", "+Default Hidden", "Add")
    btnAdd.OnEvent("Click", SubmitTask)
    myGui.OnEvent("Escape", CancelTask)
    myGui.OnEvent("Close", CancelTask)

    DllCall("AnimateWindow", "ptr", myGui.Hwnd, "uint", 150, "uint", 0x80000 | 0x20000)

    myGui.Show("AutoSize Center")

    projects := ["#Personal", "#Work"]
    labels := ["@Long", "@Short"]

    AutocompleteTrigger(ctrl, *) {
        text := ctrl.Text
        suggestions := []
        
        ; Find last occurrence of # or @
        lastHashPos := InStr(text, "#", , , -1)
        lastAtPos := InStr(text, "@", , , -1)
        triggerPos := 0
        currentTrigger := ""
        
        if (lastHashPos > lastAtPos) {
            triggerPos := lastHashPos
            currentTrigger := "#"
        } else if (lastAtPos > lastHashPos) {
            triggerPos := lastAtPos
            currentTrigger := "@"
        }
        
        if (triggerPos) {
            searchTerm := SubStr(text, triggerPos)
            if (currentTrigger = "#") {
                for val in projects {
                    if InStr(val, searchTerm)
                        suggestions.Push(val)
                }
            } else {
                for val in labels {
                    if InStr(val, searchTerm)
                        suggestions.Push(val)
                }
            }
        }

        suggestionBox.Delete()
        if suggestions.Length {
            suggestionBox.Add(suggestions)
            suggestionBox.Value := 1
            suggestionBox.Visible := true
            myGui.Show("AutoSize Center")
        } else {
            suggestionBox.Visible := false
            myGui.Show("AutoSize Center")
        }
    }

    AutocompleteSelect(ctrl, *) {
        if suggestionBox.Visible && suggestionBox.Value != "" {
            selected := suggestionBox.Text
            currentText := taskInput.Text
            ; Find last trigger position again to replace correctly
            lastHashPos := InStr(currentText, "#", , , -1)
            lastAtPos := InStr(currentText, "@", , , -1)
            
            if (lastHashPos > lastAtPos) {
                taskInput.Text := SubStr(currentText, 1, lastHashPos - 1) . selected
            } else if (lastAtPos > lastHashPos) {
                taskInput.Text := SubStr(currentText, 1, lastAtPos - 1) . selected
            }
            
            taskInput.Focus()
            SendMessage(0xB1, -1, -1, taskInput)
            SendMessage(0xB7, 0, 0, taskInput)
            
            suggestionBox.Visible := false
            myGui.Show("AutoSize Center")
        }
    }

    SubmitTask(*) {
        if suggestionBox.Visible {
            AutocompleteSelect(suggestionBox)
            return
        }
        
        task := myGui.Submit().TaskInput
        if (!task || task = "") {
            myGui.Destroy()
            return
        }

        myGui.Destroy()
        try {
            token := FileRead(A_ScriptDir "\api_token.txt")
            req := ComObject("WinHttp.WinHttpRequest.5.1")
            req.Open("POST", "https://api.todoist.com/sync/v9/quick/add", false)
            req.SetRequestHeader("Authorization", "Bearer " token)
            req.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
            req.Send("text=" . task)
            TrayTip "Task added!", "Todoist", 0x1
        } catch Error as e {
            TrayTip "Error: " e.Message, "Todoist", 0x3
        }
    }

    CancelTask(*) {
        myGui.Destroy()
    }
}