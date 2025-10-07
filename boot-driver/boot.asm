; ----------------------------------------------------------------------
; /boot/zrbl/boot-driver/boot.asm - ZRBL Stage 1 (MBR/VBR size: 512 bytes)
; ----------------------------------------------------------------------

ORG 0x7C00              ; نقطة بداية التحميل في الذاكرة (عادةً لـ MBR/VBR)

BITS 16                 ; نستخدم وضع Real Mode
JMP short start         ; القفز إلى بداية التعليمات البرمجية الفعلية

; ----------------------
; بيانات الإقلاع الأساسية
; ----------------------

DISK_DRIVE  db 0        ; سيتم ملؤه بواسطة BIOS
LOAD_SECTORS dw 30      ; عدد القطاعات المراد تحميلها للمرحلة 2
LOAD_ADDRESS dw 0x1000  ; العنوان الذي سنحمل فيه المرحلة 2 (خارج الـ 0x7C00)
LBA_LOW     dd 0x00000002 ; القطاع الأول للمرحلة 2 (مثال: يبدأ من القطاع 2)

; ----------------------
; الإجراءات
; ----------------------
start:
    ; تهيئة السجلات الأساسية
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; إعداد المؤشر المكدس (Stack Pointer)

    mov [DISK_DRIVE], dl ; تخزين رقم محرك الأقراص الذي تم الإقلاع منه

    ; رسالة ترحيب بسيطة (للتأكد من أننا عملنا)
    mov si, BootMessage
    call print_string

    ; ****** استدعاء وظيفة قراءة القطاع (LBA) *****
    call read_sectors

    ; القفز إلى المرحلة 2 التي تم تحميلها للتو
    jmp 0x0000:LOAD_ADDRESS

; ----------------------
; دالة قراءة القطاعات عبر BIOS INT 0x13
; ----------------------
read_sectors:
    pusha

    ; إعداد البارامترات لوظيفة قراءة LBA (INT 13h, AH=42h)
    mov ah, 0x42         ; الدالة: قراءة قطاعات (Read Sectors)
    mov dl, [DISK_DRIVE] ; رقم محرك الأقراص

    ; بناء حزمة المعلمات (DAP)
    mov si, DAP_address  ; عنوان حزمة المعلمات (Data Packet Address)

    ; تنفيذ القراءة
    int 0x13             ; استدعاء BIOS

    jnc read_sectors_done ; إذا لم يكن هناك خطأ، فسننتقل إلى النهاية

    ; هنا يمكن إضافة معالجة بسيطة للخطأ

read_sectors_done:
    popa
    ret

; ----------------------
; البيانات وحزمة المعلمات
; ----------------------
BootMessage db "ZRBL Stage 1 Loading...", 0x0D, 0x0A, 0

DAP_address:
    db 0x10             ; حجم حزمة المعلمات (16 بايت)
    db 0x00
    dw LOAD_SECTORS     ; عدد القطاعات المراد تحميلها
    dw LOAD_ADDRESS     ; Offset Address
    dw 0x0000           ; Segment Address (في حالتنا 0x0000)
    dd LBA_LOW          ; LBA Address Low
    dd 0x00000000       ; LBA Address High (لأننا لا نزال في 32 بت LBA)

; ----------------------
; توقيع الإقلاع الضروري
; ----------------------
times 510 - ($ - $$) db 0 ; ملء ما تبقى بالصفر
dw 0xAA55                 ; توقيع MBR/VBR

; ----------------------
; دالة طباعة بسيطة (للتجربة)
; ----------------------
print_string:
    push ax
    push bx
    push cx
    push dx
    push si

    mov ah, 0x0E ; دالة Teletype (طباعة إلى الشاشة)

.next_char:
    mov al, [si]
    cmp al, 0
    je .done
    int 0x10     ; استدعاء BIOS للطباعة
    inc si
    jmp .next_char

.done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; ----------------------------------------------------------------------
; نهاية ملف boot.asm
; ----------------------------------------------------------------------

