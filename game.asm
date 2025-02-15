; --- Constants ---
JOYSTICK   = $DC00   ; Joystick input port (player 0)
PLAYER_Y   = $01     ; Memory address storing paddle Y-position
PADDLE_MIN = 30      ; Minimum Y-position (top of screen)
PADDLE_MAX = 90      ; Maximum Y-position (bottom of screen)

; --- Update Paddle Position ---
ReadJoystick:
  LDA JOYSTICK       ; Load joystick state into accumulator

  ; Check UP direction (bit 4)
  AND #%00010000     ; Mask all bits except UP
  BNE CheckDown      ; If UP not pressed, check DOWN
  DEC PLAYER_Y       ; Move paddle UP (decrement Y)
  JMP CheckBounds    ; Ensure paddle stays in bounds

CheckDown:
  ; Check DOWN direction (bit 5)
  LDA JOYSTICK
  AND #%00100000
  BEQ CheckBounds    ; If DOWN not pressed, skip
  INC PLAYER_Y       ; Move paddle DOWN (increment Y)

CheckBounds:
  ; Clamp paddle Y between PADDLE_MIN and PADDLE_MAX
  LDA PLAYER_Y
  CMP #PADDLE_MIN
  BCS NotTooHigh     ; If >= PADDLE_MIN, skip
  LDA #PADDLE_MIN
  STA PLAYER_Y
NotTooHigh:
  CMP #PADDLE_MAX
  BCC NotTooLow      ; If < PADDLE_MAX, skip
  LDA #PADDLE_MAX
  STA PLAYER_Y
NotTooLow:

; --- Render Paddle ---
  LDA #$FF           ; Sprite pattern (solid line)
  STA GRP0           ; Store to Player 0 graphics register
  LDA PLAYER_Y       ; Set Y-position
  STA VDELP0         ; Vertical delay for positioning
  STA WSYNC          ; Wait for scanline sync
  STA HMOVE          ; Apply motion
