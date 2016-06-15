
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 a2 52 00 00       	call   c01052f0 <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 60 15 00 00       	call   c01015b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 a0 5a 10 c0 	movl   $0xc0105aa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 bc 5a 10 c0       	push   $0xc0105abc
c0100068:	e8 ff 01 00 00       	call   c010026c <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 81 08 00 00       	call   c01008f6 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 79 00 00 00       	call   c01000f3 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 23 31 00 00       	call   c01031a2 <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 a4 16 00 00       	call   c0101728 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 26 18 00 00       	call   c01018af <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 cf 0c 00 00       	call   c0100d5d <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 d2 17 00 00       	call   c0101865 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c0100093:	e8 45 01 00 00       	call   c01001dd <lab1_switch_test>

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	83 ec 04             	sub    $0x4,%esp
c01000a3:	6a 00                	push   $0x0
c01000a5:	6a 00                	push   $0x0
c01000a7:	6a 00                	push   $0x0
c01000a9:	e8 9d 0c 00 00       	call   c0100d4b <mon_backtrace>
c01000ae:	83 c4 10             	add    $0x10,%esp
}
c01000b1:	90                   	nop
c01000b2:	c9                   	leave  
c01000b3:	c3                   	ret    

c01000b4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000b4:	55                   	push   %ebp
c01000b5:	89 e5                	mov    %esp,%ebp
c01000b7:	53                   	push   %ebx
c01000b8:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000bb:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c1:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c7:	51                   	push   %ecx
c01000c8:	52                   	push   %edx
c01000c9:	53                   	push   %ebx
c01000ca:	50                   	push   %eax
c01000cb:	e8 ca ff ff ff       	call   c010009a <grade_backtrace2>
c01000d0:	83 c4 10             	add    $0x10,%esp
}
c01000d3:	90                   	nop
c01000d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000df:	83 ec 08             	sub    $0x8,%esp
c01000e2:	ff 75 10             	pushl  0x10(%ebp)
c01000e5:	ff 75 08             	pushl  0x8(%ebp)
c01000e8:	e8 c7 ff ff ff       	call   c01000b4 <grade_backtrace1>
c01000ed:	83 c4 10             	add    $0x10,%esp
}
c01000f0:	90                   	nop
c01000f1:	c9                   	leave  
c01000f2:	c3                   	ret    

c01000f3 <grade_backtrace>:

void
grade_backtrace(void) {
c01000f3:	55                   	push   %ebp
c01000f4:	89 e5                	mov    %esp,%ebp
c01000f6:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f9:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000fe:	83 ec 04             	sub    $0x4,%esp
c0100101:	68 00 00 ff ff       	push   $0xffff0000
c0100106:	50                   	push   %eax
c0100107:	6a 00                	push   $0x0
c0100109:	e8 cb ff ff ff       	call   c01000d9 <grade_backtrace0>
c010010e:	83 c4 10             	add    $0x10,%esp
}
c0100111:	90                   	nop
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010011a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010011d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100120:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100123:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100126:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010012a:	0f b7 c0             	movzwl %ax,%eax
c010012d:	83 e0 03             	and    $0x3,%eax
c0100130:	89 c2                	mov    %eax,%edx
c0100132:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100137:	83 ec 04             	sub    $0x4,%esp
c010013a:	52                   	push   %edx
c010013b:	50                   	push   %eax
c010013c:	68 c1 5a 10 c0       	push   $0xc0105ac1
c0100141:	e8 26 01 00 00       	call   c010026c <cprintf>
c0100146:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100149:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014d:	0f b7 d0             	movzwl %ax,%edx
c0100150:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100155:	83 ec 04             	sub    $0x4,%esp
c0100158:	52                   	push   %edx
c0100159:	50                   	push   %eax
c010015a:	68 cf 5a 10 c0       	push   $0xc0105acf
c010015f:	e8 08 01 00 00       	call   c010026c <cprintf>
c0100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100167:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010016b:	0f b7 d0             	movzwl %ax,%edx
c010016e:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100173:	83 ec 04             	sub    $0x4,%esp
c0100176:	52                   	push   %edx
c0100177:	50                   	push   %eax
c0100178:	68 dd 5a 10 c0       	push   $0xc0105add
c010017d:	e8 ea 00 00 00       	call   c010026c <cprintf>
c0100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100185:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100191:	83 ec 04             	sub    $0x4,%esp
c0100194:	52                   	push   %edx
c0100195:	50                   	push   %eax
c0100196:	68 eb 5a 10 c0       	push   $0xc0105aeb
c010019b:	e8 cc 00 00 00       	call   c010026c <cprintf>
c01001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a7:	0f b7 d0             	movzwl %ax,%edx
c01001aa:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001af:	83 ec 04             	sub    $0x4,%esp
c01001b2:	52                   	push   %edx
c01001b3:	50                   	push   %eax
c01001b4:	68 f9 5a 10 c0       	push   $0xc0105af9
c01001b9:	e8 ae 00 00 00       	call   c010026c <cprintf>
c01001be:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c6:	83 c0 01             	add    $0x1,%eax
c01001c9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ce:	90                   	nop
c01001cf:	c9                   	leave  
c01001d0:	c3                   	ret    

c01001d1 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d1:	55                   	push   %ebp
c01001d2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001d4:	90                   	nop
c01001d5:	5d                   	pop    %ebp
c01001d6:	c3                   	ret    

c01001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d7:	55                   	push   %ebp
c01001d8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001da:	90                   	nop
c01001db:	5d                   	pop    %ebp
c01001dc:	c3                   	ret    

c01001dd <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001dd:	55                   	push   %ebp
c01001de:	89 e5                	mov    %esp,%ebp
c01001e0:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001e3:	e8 2c ff ff ff       	call   c0100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e8:	83 ec 0c             	sub    $0xc,%esp
c01001eb:	68 08 5b 10 c0       	push   $0xc0105b08
c01001f0:	e8 77 00 00 00       	call   c010026c <cprintf>
c01001f5:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f8:	e8 d4 ff ff ff       	call   c01001d1 <lab1_switch_to_user>
    lab1_print_cur_status();
c01001fd:	e8 12 ff ff ff       	call   c0100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100202:	83 ec 0c             	sub    $0xc,%esp
c0100205:	68 28 5b 10 c0       	push   $0xc0105b28
c010020a:	e8 5d 00 00 00       	call   c010026c <cprintf>
c010020f:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100212:	e8 c0 ff ff ff       	call   c01001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100217:	e8 f8 fe ff ff       	call   c0100114 <lab1_print_cur_status>
}
c010021c:	90                   	nop
c010021d:	c9                   	leave  
c010021e:	c3                   	ret    

c010021f <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021f:	55                   	push   %ebp
c0100220:	89 e5                	mov    %esp,%ebp
c0100222:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100225:	83 ec 0c             	sub    $0xc,%esp
c0100228:	ff 75 08             	pushl  0x8(%ebp)
c010022b:	e8 b7 13 00 00       	call   c01015e7 <cons_putc>
c0100230:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c0100233:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100236:	8b 00                	mov    (%eax),%eax
c0100238:	8d 50 01             	lea    0x1(%eax),%edx
c010023b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010023e:	89 10                	mov    %edx,(%eax)
}
c0100240:	90                   	nop
c0100241:	c9                   	leave  
c0100242:	c3                   	ret    

c0100243 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100243:	55                   	push   %ebp
c0100244:	89 e5                	mov    %esp,%ebp
c0100246:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100250:	ff 75 0c             	pushl  0xc(%ebp)
c0100253:	ff 75 08             	pushl  0x8(%ebp)
c0100256:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100259:	50                   	push   %eax
c010025a:	68 1f 02 10 c0       	push   $0xc010021f
c010025f:	e8 c2 53 00 00       	call   c0105626 <vprintfmt>
c0100264:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010026a:	c9                   	leave  
c010026b:	c3                   	ret    

c010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010026c:	55                   	push   %ebp
c010026d:	89 e5                	mov    %esp,%ebp
c010026f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100272:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010027b:	83 ec 08             	sub    $0x8,%esp
c010027e:	50                   	push   %eax
c010027f:	ff 75 08             	pushl  0x8(%ebp)
c0100282:	e8 bc ff ff ff       	call   c0100243 <vcprintf>
c0100287:	83 c4 10             	add    $0x10,%esp
c010028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100290:	c9                   	leave  
c0100291:	c3                   	ret    

c0100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100298:	83 ec 0c             	sub    $0xc,%esp
c010029b:	ff 75 08             	pushl  0x8(%ebp)
c010029e:	e8 44 13 00 00       	call   c01015e7 <cons_putc>
c01002a3:	83 c4 10             	add    $0x10,%esp
}
c01002a6:	90                   	nop
c01002a7:	c9                   	leave  
c01002a8:	c3                   	ret    

c01002a9 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a9:	55                   	push   %ebp
c01002aa:	89 e5                	mov    %esp,%ebp
c01002ac:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b6:	eb 14                	jmp    c01002cc <cputs+0x23>
        cputch(c, &cnt);
c01002b8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002bc:	83 ec 08             	sub    $0x8,%esp
c01002bf:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002c2:	52                   	push   %edx
c01002c3:	50                   	push   %eax
c01002c4:	e8 56 ff ff ff       	call   c010021f <cputch>
c01002c9:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002cf:	8d 50 01             	lea    0x1(%eax),%edx
c01002d2:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d5:	0f b6 00             	movzbl (%eax),%eax
c01002d8:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002db:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002df:	75 d7                	jne    c01002b8 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002e1:	83 ec 08             	sub    $0x8,%esp
c01002e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e7:	50                   	push   %eax
c01002e8:	6a 0a                	push   $0xa
c01002ea:	e8 30 ff ff ff       	call   c010021f <cputch>
c01002ef:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f5:	c9                   	leave  
c01002f6:	c3                   	ret    

c01002f7 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f7:	55                   	push   %ebp
c01002f8:	89 e5                	mov    %esp,%ebp
c01002fa:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002fd:	e8 2e 13 00 00       	call   c0101630 <cons_getc>
c0100302:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100309:	74 f2                	je     c01002fd <getchar+0x6>
        /* do nothing */;
    return c;
c010030b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010030e:	c9                   	leave  
c010030f:	c3                   	ret    

c0100310 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100310:	55                   	push   %ebp
c0100311:	89 e5                	mov    %esp,%ebp
c0100313:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010031a:	74 13                	je     c010032f <readline+0x1f>
        cprintf("%s", prompt);
c010031c:	83 ec 08             	sub    $0x8,%esp
c010031f:	ff 75 08             	pushl  0x8(%ebp)
c0100322:	68 47 5b 10 c0       	push   $0xc0105b47
c0100327:	e8 40 ff ff ff       	call   c010026c <cprintf>
c010032c:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100336:	e8 bc ff ff ff       	call   c01002f7 <getchar>
c010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010033e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100342:	79 0a                	jns    c010034e <readline+0x3e>
            return NULL;
c0100344:	b8 00 00 00 00       	mov    $0x0,%eax
c0100349:	e9 82 00 00 00       	jmp    c01003d0 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010034e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100352:	7e 2b                	jle    c010037f <readline+0x6f>
c0100354:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010035b:	7f 22                	jg     c010037f <readline+0x6f>
            cputchar(c);
c010035d:	83 ec 0c             	sub    $0xc,%esp
c0100360:	ff 75 f0             	pushl  -0x10(%ebp)
c0100363:	e8 2a ff ff ff       	call   c0100292 <cputchar>
c0100368:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010036b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010036e:	8d 50 01             	lea    0x1(%eax),%edx
c0100371:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100374:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100377:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010037d:	eb 4c                	jmp    c01003cb <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100383:	75 1a                	jne    c010039f <readline+0x8f>
c0100385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100389:	7e 14                	jle    c010039f <readline+0x8f>
            cputchar(c);
c010038b:	83 ec 0c             	sub    $0xc,%esp
c010038e:	ff 75 f0             	pushl  -0x10(%ebp)
c0100391:	e8 fc fe ff ff       	call   c0100292 <cputchar>
c0100396:	83 c4 10             	add    $0x10,%esp
            i --;
c0100399:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010039d:	eb 2c                	jmp    c01003cb <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003a3:	74 06                	je     c01003ab <readline+0x9b>
c01003a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a9:	75 8b                	jne    c0100336 <readline+0x26>
            cputchar(c);
c01003ab:	83 ec 0c             	sub    $0xc,%esp
c01003ae:	ff 75 f0             	pushl  -0x10(%ebp)
c01003b1:	e8 dc fe ff ff       	call   c0100292 <cputchar>
c01003b6:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003bc:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003c1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003c4:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003c9:	eb 05                	jmp    c01003d0 <readline+0xc0>
        }
    }
c01003cb:	e9 66 ff ff ff       	jmp    c0100336 <readline+0x26>
}
c01003d0:	c9                   	leave  
c01003d1:	c3                   	ret    

c01003d2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003d2:	55                   	push   %ebp
c01003d3:	89 e5                	mov    %esp,%ebp
c01003d5:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d8:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003dd:	85 c0                	test   %eax,%eax
c01003df:	75 4a                	jne    c010042b <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003e1:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003e8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003eb:	8d 45 14             	lea    0x14(%ebp),%eax
c01003ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003f1:	83 ec 04             	sub    $0x4,%esp
c01003f4:	ff 75 0c             	pushl  0xc(%ebp)
c01003f7:	ff 75 08             	pushl  0x8(%ebp)
c01003fa:	68 4a 5b 10 c0       	push   $0xc0105b4a
c01003ff:	e8 68 fe ff ff       	call   c010026c <cprintf>
c0100404:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100407:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010040a:	83 ec 08             	sub    $0x8,%esp
c010040d:	50                   	push   %eax
c010040e:	ff 75 10             	pushl  0x10(%ebp)
c0100411:	e8 2d fe ff ff       	call   c0100243 <vcprintf>
c0100416:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100419:	83 ec 0c             	sub    $0xc,%esp
c010041c:	68 66 5b 10 c0       	push   $0xc0105b66
c0100421:	e8 46 fe ff ff       	call   c010026c <cprintf>
c0100426:	83 c4 10             	add    $0x10,%esp
c0100429:	eb 01                	jmp    c010042c <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010042b:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c010042c:	e8 3b 14 00 00       	call   c010186c <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100431:	83 ec 0c             	sub    $0xc,%esp
c0100434:	6a 00                	push   $0x0
c0100436:	e8 36 08 00 00       	call   c0100c71 <kmonitor>
c010043b:	83 c4 10             	add    $0x10,%esp
    }
c010043e:	eb f1                	jmp    c0100431 <__panic+0x5f>

c0100440 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100440:	55                   	push   %ebp
c0100441:	89 e5                	mov    %esp,%ebp
c0100443:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100446:	8d 45 14             	lea    0x14(%ebp),%eax
c0100449:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010044c:	83 ec 04             	sub    $0x4,%esp
c010044f:	ff 75 0c             	pushl  0xc(%ebp)
c0100452:	ff 75 08             	pushl  0x8(%ebp)
c0100455:	68 68 5b 10 c0       	push   $0xc0105b68
c010045a:	e8 0d fe ff ff       	call   c010026c <cprintf>
c010045f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100462:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100465:	83 ec 08             	sub    $0x8,%esp
c0100468:	50                   	push   %eax
c0100469:	ff 75 10             	pushl  0x10(%ebp)
c010046c:	e8 d2 fd ff ff       	call   c0100243 <vcprintf>
c0100471:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100474:	83 ec 0c             	sub    $0xc,%esp
c0100477:	68 66 5b 10 c0       	push   $0xc0105b66
c010047c:	e8 eb fd ff ff       	call   c010026c <cprintf>
c0100481:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100484:	90                   	nop
c0100485:	c9                   	leave  
c0100486:	c3                   	ret    

c0100487 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100487:	55                   	push   %ebp
c0100488:	89 e5                	mov    %esp,%ebp
    return is_panic;
c010048a:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010048f:	5d                   	pop    %ebp
c0100490:	c3                   	ret    

c0100491 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100491:	55                   	push   %ebp
c0100492:	89 e5                	mov    %esp,%ebp
c0100494:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100497:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049a:	8b 00                	mov    (%eax),%eax
c010049c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049f:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a2:	8b 00                	mov    (%eax),%eax
c01004a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ae:	e9 d2 00 00 00       	jmp    c0100585 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b9:	01 d0                	add    %edx,%eax
c01004bb:	89 c2                	mov    %eax,%edx
c01004bd:	c1 ea 1f             	shr    $0x1f,%edx
c01004c0:	01 d0                	add    %edx,%eax
c01004c2:	d1 f8                	sar    %eax
c01004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004cd:	eb 04                	jmp    c01004d3 <stab_binsearch+0x42>
            m --;
c01004cf:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d9:	7c 1f                	jl     c01004fa <stab_binsearch+0x69>
c01004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004de:	89 d0                	mov    %edx,%eax
c01004e0:	01 c0                	add    %eax,%eax
c01004e2:	01 d0                	add    %edx,%eax
c01004e4:	c1 e0 02             	shl    $0x2,%eax
c01004e7:	89 c2                	mov    %eax,%edx
c01004e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ec:	01 d0                	add    %edx,%eax
c01004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004f2:	0f b6 c0             	movzbl %al,%eax
c01004f5:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f8:	75 d5                	jne    c01004cf <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100500:	7d 0b                	jge    c010050d <stab_binsearch+0x7c>
            l = true_m + 1;
c0100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100505:	83 c0 01             	add    $0x1,%eax
c0100508:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010050b:	eb 78                	jmp    c0100585 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010050d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100514:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100517:	89 d0                	mov    %edx,%eax
c0100519:	01 c0                	add    %eax,%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	c1 e0 02             	shl    $0x2,%eax
c0100520:	89 c2                	mov    %eax,%edx
c0100522:	8b 45 08             	mov    0x8(%ebp),%eax
c0100525:	01 d0                	add    %edx,%eax
c0100527:	8b 40 08             	mov    0x8(%eax),%eax
c010052a:	3b 45 18             	cmp    0x18(%ebp),%eax
c010052d:	73 13                	jae    c0100542 <stab_binsearch+0xb1>
            *region_left = m;
c010052f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100532:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100535:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100537:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010053a:	83 c0 01             	add    $0x1,%eax
c010053d:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100540:	eb 43                	jmp    c0100585 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100542:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100545:	89 d0                	mov    %edx,%eax
c0100547:	01 c0                	add    %eax,%eax
c0100549:	01 d0                	add    %edx,%eax
c010054b:	c1 e0 02             	shl    $0x2,%eax
c010054e:	89 c2                	mov    %eax,%edx
c0100550:	8b 45 08             	mov    0x8(%ebp),%eax
c0100553:	01 d0                	add    %edx,%eax
c0100555:	8b 40 08             	mov    0x8(%eax),%eax
c0100558:	3b 45 18             	cmp    0x18(%ebp),%eax
c010055b:	76 16                	jbe    c0100573 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010055d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100560:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100563:	8b 45 10             	mov    0x10(%ebp),%eax
c0100566:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100568:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010056b:	83 e8 01             	sub    $0x1,%eax
c010056e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100571:	eb 12                	jmp    c0100585 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100573:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100576:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100579:	89 10                	mov    %edx,(%eax)
            l = m;
c010057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c0100581:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100585:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100588:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010058b:	0f 8e 22 ff ff ff    	jle    c01004b3 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c0100591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100595:	75 0f                	jne    c01005a6 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100597:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059a:	8b 00                	mov    (%eax),%eax
c010059c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059f:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a2:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005a4:	eb 3f                	jmp    c01005e5 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a9:	8b 00                	mov    (%eax),%eax
c01005ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005ae:	eb 04                	jmp    c01005b4 <stab_binsearch+0x123>
c01005b0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b7:	8b 00                	mov    (%eax),%eax
c01005b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005bc:	7d 1f                	jge    c01005dd <stab_binsearch+0x14c>
c01005be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005c1:	89 d0                	mov    %edx,%eax
c01005c3:	01 c0                	add    %eax,%eax
c01005c5:	01 d0                	add    %edx,%eax
c01005c7:	c1 e0 02             	shl    $0x2,%eax
c01005ca:	89 c2                	mov    %eax,%edx
c01005cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01005cf:	01 d0                	add    %edx,%eax
c01005d1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d5:	0f b6 c0             	movzbl %al,%eax
c01005d8:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005db:	75 d3                	jne    c01005b0 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005e3:	89 10                	mov    %edx,(%eax)
    }
}
c01005e5:	90                   	nop
c01005e6:	c9                   	leave  
c01005e7:	c3                   	ret    

c01005e8 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e8:	55                   	push   %ebp
c01005e9:	89 e5                	mov    %esp,%ebp
c01005eb:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f1:	c7 00 88 5b 10 c0    	movl   $0xc0105b88,(%eax)
    info->eip_line = 0;
c01005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100601:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100604:	c7 40 08 88 5b 10 c0 	movl   $0xc0105b88,0x8(%eax)
    info->eip_fn_namelen = 9;
c010060b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060e:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	8b 55 08             	mov    0x8(%ebp),%edx
c010061b:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010061e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100621:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100628:	c7 45 f4 b0 6d 10 c0 	movl   $0xc0106db0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062f:	c7 45 f0 34 1c 11 c0 	movl   $0xc0111c34,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100636:	c7 45 ec 35 1c 11 c0 	movl   $0xc0111c35,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010063d:	c7 45 e8 cf 46 11 c0 	movl   $0xc01146cf,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100647:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010064a:	76 0d                	jbe    c0100659 <debuginfo_eip+0x71>
c010064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064f:	83 e8 01             	sub    $0x1,%eax
c0100652:	0f b6 00             	movzbl (%eax),%eax
c0100655:	84 c0                	test   %al,%al
c0100657:	74 0a                	je     c0100663 <debuginfo_eip+0x7b>
        return -1;
c0100659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010065e:	e9 91 02 00 00       	jmp    c01008f4 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010066a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010066d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100670:	29 c2                	sub    %eax,%edx
c0100672:	89 d0                	mov    %edx,%eax
c0100674:	c1 f8 02             	sar    $0x2,%eax
c0100677:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c010067d:	83 e8 01             	sub    $0x1,%eax
c0100680:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100683:	ff 75 08             	pushl  0x8(%ebp)
c0100686:	6a 64                	push   $0x64
c0100688:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010068b:	50                   	push   %eax
c010068c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068f:	50                   	push   %eax
c0100690:	ff 75 f4             	pushl  -0xc(%ebp)
c0100693:	e8 f9 fd ff ff       	call   c0100491 <stab_binsearch>
c0100698:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c010069b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010069e:	85 c0                	test   %eax,%eax
c01006a0:	75 0a                	jne    c01006ac <debuginfo_eip+0xc4>
        return -1;
c01006a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a7:	e9 48 02 00 00       	jmp    c01008f4 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006af:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b8:	ff 75 08             	pushl  0x8(%ebp)
c01006bb:	6a 24                	push   $0x24
c01006bd:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006c0:	50                   	push   %eax
c01006c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006c4:	50                   	push   %eax
c01006c5:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c8:	e8 c4 fd ff ff       	call   c0100491 <stab_binsearch>
c01006cd:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d6:	39 c2                	cmp    %eax,%edx
c01006d8:	7f 7c                	jg     c0100756 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006dd:	89 c2                	mov    %eax,%edx
c01006df:	89 d0                	mov    %edx,%eax
c01006e1:	01 c0                	add    %eax,%eax
c01006e3:	01 d0                	add    %edx,%eax
c01006e5:	c1 e0 02             	shl    $0x2,%eax
c01006e8:	89 c2                	mov    %eax,%edx
c01006ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ed:	01 d0                	add    %edx,%eax
c01006ef:	8b 00                	mov    (%eax),%eax
c01006f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f7:	29 d1                	sub    %edx,%ecx
c01006f9:	89 ca                	mov    %ecx,%edx
c01006fb:	39 d0                	cmp    %edx,%eax
c01006fd:	73 22                	jae    c0100721 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100702:	89 c2                	mov    %eax,%edx
c0100704:	89 d0                	mov    %edx,%eax
c0100706:	01 c0                	add    %eax,%eax
c0100708:	01 d0                	add    %edx,%eax
c010070a:	c1 e0 02             	shl    $0x2,%eax
c010070d:	89 c2                	mov    %eax,%edx
c010070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100712:	01 d0                	add    %edx,%eax
c0100714:	8b 10                	mov    (%eax),%edx
c0100716:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100719:	01 c2                	add    %eax,%edx
c010071b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010071e:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100721:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100724:	89 c2                	mov    %eax,%edx
c0100726:	89 d0                	mov    %edx,%eax
c0100728:	01 c0                	add    %eax,%eax
c010072a:	01 d0                	add    %edx,%eax
c010072c:	c1 e0 02             	shl    $0x2,%eax
c010072f:	89 c2                	mov    %eax,%edx
c0100731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100734:	01 d0                	add    %edx,%eax
c0100736:	8b 50 08             	mov    0x8(%eax),%edx
c0100739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073c:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100742:	8b 40 10             	mov    0x10(%eax),%eax
c0100745:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100748:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010074e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100751:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100754:	eb 15                	jmp    c010076b <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	8b 55 08             	mov    0x8(%ebp),%edx
c010075c:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100765:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100768:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c010076b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076e:	8b 40 08             	mov    0x8(%eax),%eax
c0100771:	83 ec 08             	sub    $0x8,%esp
c0100774:	6a 3a                	push   $0x3a
c0100776:	50                   	push   %eax
c0100777:	e8 e8 49 00 00       	call   c0105164 <strfind>
c010077c:	83 c4 10             	add    $0x10,%esp
c010077f:	89 c2                	mov    %eax,%edx
c0100781:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100784:	8b 40 08             	mov    0x8(%eax),%eax
c0100787:	29 c2                	sub    %eax,%edx
c0100789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078f:	83 ec 0c             	sub    $0xc,%esp
c0100792:	ff 75 08             	pushl  0x8(%ebp)
c0100795:	6a 44                	push   $0x44
c0100797:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010079a:	50                   	push   %eax
c010079b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010079e:	50                   	push   %eax
c010079f:	ff 75 f4             	pushl  -0xc(%ebp)
c01007a2:	e8 ea fc ff ff       	call   c0100491 <stab_binsearch>
c01007a7:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b0:	39 c2                	cmp    %eax,%edx
c01007b2:	7f 24                	jg     c01007d8 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	89 d0                	mov    %edx,%eax
c01007bb:	01 c0                	add    %eax,%eax
c01007bd:	01 d0                	add    %edx,%eax
c01007bf:	c1 e0 02             	shl    $0x2,%eax
c01007c2:	89 c2                	mov    %eax,%edx
c01007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c7:	01 d0                	add    %edx,%eax
c01007c9:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007cd:	0f b7 d0             	movzwl %ax,%edx
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d6:	eb 13                	jmp    c01007eb <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007dd:	e9 12 01 00 00       	jmp    c01008f4 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e5:	83 e8 01             	sub    $0x1,%eax
c01007e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f1:	39 c2                	cmp    %eax,%edx
c01007f3:	7c 56                	jl     c010084b <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f8:	89 c2                	mov    %eax,%edx
c01007fa:	89 d0                	mov    %edx,%eax
c01007fc:	01 c0                	add    %eax,%eax
c01007fe:	01 d0                	add    %edx,%eax
c0100800:	c1 e0 02             	shl    $0x2,%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010080e:	3c 84                	cmp    $0x84,%al
c0100810:	74 39                	je     c010084b <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100815:	89 c2                	mov    %eax,%edx
c0100817:	89 d0                	mov    %edx,%eax
c0100819:	01 c0                	add    %eax,%eax
c010081b:	01 d0                	add    %edx,%eax
c010081d:	c1 e0 02             	shl    $0x2,%eax
c0100820:	89 c2                	mov    %eax,%edx
c0100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100825:	01 d0                	add    %edx,%eax
c0100827:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010082b:	3c 64                	cmp    $0x64,%al
c010082d:	75 b3                	jne    c01007e2 <debuginfo_eip+0x1fa>
c010082f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100832:	89 c2                	mov    %eax,%edx
c0100834:	89 d0                	mov    %edx,%eax
c0100836:	01 c0                	add    %eax,%eax
c0100838:	01 d0                	add    %edx,%eax
c010083a:	c1 e0 02             	shl    $0x2,%eax
c010083d:	89 c2                	mov    %eax,%edx
c010083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100842:	01 d0                	add    %edx,%eax
c0100844:	8b 40 08             	mov    0x8(%eax),%eax
c0100847:	85 c0                	test   %eax,%eax
c0100849:	74 97                	je     c01007e2 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010084b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100851:	39 c2                	cmp    %eax,%edx
c0100853:	7c 46                	jl     c010089b <debuginfo_eip+0x2b3>
c0100855:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100858:	89 c2                	mov    %eax,%edx
c010085a:	89 d0                	mov    %edx,%eax
c010085c:	01 c0                	add    %eax,%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	c1 e0 02             	shl    $0x2,%eax
c0100863:	89 c2                	mov    %eax,%edx
c0100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100868:	01 d0                	add    %edx,%eax
c010086a:	8b 00                	mov    (%eax),%eax
c010086c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100872:	29 d1                	sub    %edx,%ecx
c0100874:	89 ca                	mov    %ecx,%edx
c0100876:	39 d0                	cmp    %edx,%eax
c0100878:	73 21                	jae    c010089b <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010087a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010087d:	89 c2                	mov    %eax,%edx
c010087f:	89 d0                	mov    %edx,%eax
c0100881:	01 c0                	add    %eax,%eax
c0100883:	01 d0                	add    %edx,%eax
c0100885:	c1 e0 02             	shl    $0x2,%eax
c0100888:	89 c2                	mov    %eax,%edx
c010088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010088d:	01 d0                	add    %edx,%eax
c010088f:	8b 10                	mov    (%eax),%edx
c0100891:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100894:	01 c2                	add    %eax,%edx
c0100896:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100899:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010089b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008a1:	39 c2                	cmp    %eax,%edx
c01008a3:	7d 4a                	jge    c01008ef <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a8:	83 c0 01             	add    $0x1,%eax
c01008ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ae:	eb 18                	jmp    c01008c8 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b3:	8b 40 14             	mov    0x14(%eax),%eax
c01008b6:	8d 50 01             	lea    0x1(%eax),%edx
c01008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008bc:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c2:	83 c0 01             	add    $0x1,%eax
c01008c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008ce:	39 c2                	cmp    %eax,%edx
c01008d0:	7d 1d                	jge    c01008ef <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d5:	89 c2                	mov    %eax,%edx
c01008d7:	89 d0                	mov    %edx,%eax
c01008d9:	01 c0                	add    %eax,%eax
c01008db:	01 d0                	add    %edx,%eax
c01008dd:	c1 e0 02             	shl    $0x2,%eax
c01008e0:	89 c2                	mov    %eax,%edx
c01008e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e5:	01 d0                	add    %edx,%eax
c01008e7:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008eb:	3c a0                	cmp    $0xa0,%al
c01008ed:	74 c1                	je     c01008b0 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008f4:	c9                   	leave  
c01008f5:	c3                   	ret    

c01008f6 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f6:	55                   	push   %ebp
c01008f7:	89 e5                	mov    %esp,%ebp
c01008f9:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008fc:	83 ec 0c             	sub    $0xc,%esp
c01008ff:	68 92 5b 10 c0       	push   $0xc0105b92
c0100904:	e8 63 f9 ff ff       	call   c010026c <cprintf>
c0100909:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010090c:	83 ec 08             	sub    $0x8,%esp
c010090f:	68 2a 00 10 c0       	push   $0xc010002a
c0100914:	68 ab 5b 10 c0       	push   $0xc0105bab
c0100919:	e8 4e f9 ff ff       	call   c010026c <cprintf>
c010091e:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100921:	83 ec 08             	sub    $0x8,%esp
c0100924:	68 87 5a 10 c0       	push   $0xc0105a87
c0100929:	68 c3 5b 10 c0       	push   $0xc0105bc3
c010092e:	e8 39 f9 ff ff       	call   c010026c <cprintf>
c0100933:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100936:	83 ec 08             	sub    $0x8,%esp
c0100939:	68 36 7a 11 c0       	push   $0xc0117a36
c010093e:	68 db 5b 10 c0       	push   $0xc0105bdb
c0100943:	e8 24 f9 ff ff       	call   c010026c <cprintf>
c0100948:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c010094b:	83 ec 08             	sub    $0x8,%esp
c010094e:	68 68 89 11 c0       	push   $0xc0118968
c0100953:	68 f3 5b 10 c0       	push   $0xc0105bf3
c0100958:	e8 0f f9 ff ff       	call   c010026c <cprintf>
c010095d:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100960:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100965:	05 ff 03 00 00       	add    $0x3ff,%eax
c010096a:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096f:	29 d0                	sub    %edx,%eax
c0100971:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100977:	85 c0                	test   %eax,%eax
c0100979:	0f 48 c2             	cmovs  %edx,%eax
c010097c:	c1 f8 0a             	sar    $0xa,%eax
c010097f:	83 ec 08             	sub    $0x8,%esp
c0100982:	50                   	push   %eax
c0100983:	68 0c 5c 10 c0       	push   $0xc0105c0c
c0100988:	e8 df f8 ff ff       	call   c010026c <cprintf>
c010098d:	83 c4 10             	add    $0x10,%esp
}
c0100990:	90                   	nop
c0100991:	c9                   	leave  
c0100992:	c3                   	ret    

c0100993 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100993:	55                   	push   %ebp
c0100994:	89 e5                	mov    %esp,%ebp
c0100996:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010099c:	83 ec 08             	sub    $0x8,%esp
c010099f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009a2:	50                   	push   %eax
c01009a3:	ff 75 08             	pushl  0x8(%ebp)
c01009a6:	e8 3d fc ff ff       	call   c01005e8 <debuginfo_eip>
c01009ab:	83 c4 10             	add    $0x10,%esp
c01009ae:	85 c0                	test   %eax,%eax
c01009b0:	74 15                	je     c01009c7 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009b2:	83 ec 08             	sub    $0x8,%esp
c01009b5:	ff 75 08             	pushl  0x8(%ebp)
c01009b8:	68 36 5c 10 c0       	push   $0xc0105c36
c01009bd:	e8 aa f8 ff ff       	call   c010026c <cprintf>
c01009c2:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c5:	eb 65                	jmp    c0100a2c <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009ce:	eb 1c                	jmp    c01009ec <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d6:	01 d0                	add    %edx,%eax
c01009d8:	0f b6 00             	movzbl (%eax),%eax
c01009db:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009e4:	01 ca                	add    %ecx,%edx
c01009e6:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009f2:	7f dc                	jg     c01009d0 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009f4:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fd:	01 d0                	add    %edx,%eax
c01009ff:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a05:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a08:	89 d1                	mov    %edx,%ecx
c0100a0a:	29 c1                	sub    %eax,%ecx
c0100a0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a12:	83 ec 0c             	sub    $0xc,%esp
c0100a15:	51                   	push   %ecx
c0100a16:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1c:	51                   	push   %ecx
c0100a1d:	52                   	push   %edx
c0100a1e:	50                   	push   %eax
c0100a1f:	68 52 5c 10 c0       	push   $0xc0105c52
c0100a24:	e8 43 f8 ff ff       	call   c010026c <cprintf>
c0100a29:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a2c:	90                   	nop
c0100a2d:	c9                   	leave  
c0100a2e:	c3                   	ret    

c0100a2f <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2f:	55                   	push   %ebp
c0100a30:	89 e5                	mov    %esp,%ebp
c0100a32:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a35:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a38:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a3e:	c9                   	leave  
c0100a3f:	c3                   	ret    

c0100a40 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a40:	55                   	push   %ebp
c0100a41:	89 e5                	mov    %esp,%ebp
c0100a43:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a46:	89 e8                	mov    %ebp,%eax
c0100a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp(), eip = read_eip();
c0100a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100a51:	e8 d9 ff ff ff       	call   c0100a2f <read_eip>
c0100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a60:	e9 8d 00 00 00       	jmp    c0100af2 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100a65:	83 ec 04             	sub    $0x4,%esp
c0100a68:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a6b:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a6e:	68 64 5c 10 c0       	push   $0xc0105c64
c0100a73:	e8 f4 f7 ff ff       	call   c010026c <cprintf>
c0100a78:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7e:	83 c0 08             	add    $0x8,%eax
c0100a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a84:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a8b:	eb 26                	jmp    c0100ab3 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
c0100a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a9a:	01 d0                	add    %edx,%eax
c0100a9c:	8b 00                	mov    (%eax),%eax
c0100a9e:	83 ec 08             	sub    $0x8,%esp
c0100aa1:	50                   	push   %eax
c0100aa2:	68 80 5c 10 c0       	push   $0xc0105c80
c0100aa7:	e8 c0 f7 ff ff       	call   c010026c <cprintf>
c0100aac:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100aaf:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100ab3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ab7:	7e d4                	jle    c0100a8d <print_stackframe+0x4d>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100ab9:	83 ec 0c             	sub    $0xc,%esp
c0100abc:	68 88 5c 10 c0       	push   $0xc0105c88
c0100ac1:	e8 a6 f7 ff ff       	call   c010026c <cprintf>
c0100ac6:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100acc:	83 e8 01             	sub    $0x1,%eax
c0100acf:	83 ec 0c             	sub    $0xc,%esp
c0100ad2:	50                   	push   %eax
c0100ad3:	e8 bb fe ff ff       	call   c0100993 <print_debuginfo>
c0100ad8:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ade:	83 c0 04             	add    $0x4,%eax
c0100ae1:	8b 00                	mov    (%eax),%eax
c0100ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae9:	8b 00                	mov    (%eax),%eax
c0100aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100aee:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100af6:	74 0a                	je     c0100b02 <print_stackframe+0xc2>
c0100af8:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100afc:	0f 8e 63 ff ff ff    	jle    c0100a65 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100b02:	90                   	nop
c0100b03:	c9                   	leave  
c0100b04:	c3                   	ret    

c0100b05 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b05:	55                   	push   %ebp
c0100b06:	89 e5                	mov    %esp,%ebp
c0100b08:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b12:	eb 0c                	jmp    c0100b20 <parse+0x1b>
            *buf ++ = '\0';
c0100b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b17:	8d 50 01             	lea    0x1(%eax),%edx
c0100b1a:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b1d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b23:	0f b6 00             	movzbl (%eax),%eax
c0100b26:	84 c0                	test   %al,%al
c0100b28:	74 1e                	je     c0100b48 <parse+0x43>
c0100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b2d:	0f b6 00             	movzbl (%eax),%eax
c0100b30:	0f be c0             	movsbl %al,%eax
c0100b33:	83 ec 08             	sub    $0x8,%esp
c0100b36:	50                   	push   %eax
c0100b37:	68 0c 5d 10 c0       	push   $0xc0105d0c
c0100b3c:	e8 f0 45 00 00       	call   c0105131 <strchr>
c0100b41:	83 c4 10             	add    $0x10,%esp
c0100b44:	85 c0                	test   %eax,%eax
c0100b46:	75 cc                	jne    c0100b14 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4b:	0f b6 00             	movzbl (%eax),%eax
c0100b4e:	84 c0                	test   %al,%al
c0100b50:	74 69                	je     c0100bbb <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b52:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b56:	75 12                	jne    c0100b6a <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b58:	83 ec 08             	sub    $0x8,%esp
c0100b5b:	6a 10                	push   $0x10
c0100b5d:	68 11 5d 10 c0       	push   $0xc0105d11
c0100b62:	e8 05 f7 ff ff       	call   c010026c <cprintf>
c0100b67:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8d 50 01             	lea    0x1(%eax),%edx
c0100b70:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b7d:	01 c2                	add    %eax,%edx
c0100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b82:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b84:	eb 04                	jmp    c0100b8a <parse+0x85>
            buf ++;
c0100b86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8d:	0f b6 00             	movzbl (%eax),%eax
c0100b90:	84 c0                	test   %al,%al
c0100b92:	0f 84 7a ff ff ff    	je     c0100b12 <parse+0xd>
c0100b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9b:	0f b6 00             	movzbl (%eax),%eax
c0100b9e:	0f be c0             	movsbl %al,%eax
c0100ba1:	83 ec 08             	sub    $0x8,%esp
c0100ba4:	50                   	push   %eax
c0100ba5:	68 0c 5d 10 c0       	push   $0xc0105d0c
c0100baa:	e8 82 45 00 00       	call   c0105131 <strchr>
c0100baf:	83 c4 10             	add    $0x10,%esp
c0100bb2:	85 c0                	test   %eax,%eax
c0100bb4:	74 d0                	je     c0100b86 <parse+0x81>
            buf ++;
        }
    }
c0100bb6:	e9 57 ff ff ff       	jmp    c0100b12 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bbb:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bbf:	c9                   	leave  
c0100bc0:	c3                   	ret    

c0100bc1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bc1:	55                   	push   %ebp
c0100bc2:	89 e5                	mov    %esp,%ebp
c0100bc4:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bc7:	83 ec 08             	sub    $0x8,%esp
c0100bca:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bcd:	50                   	push   %eax
c0100bce:	ff 75 08             	pushl  0x8(%ebp)
c0100bd1:	e8 2f ff ff ff       	call   c0100b05 <parse>
c0100bd6:	83 c4 10             	add    $0x10,%esp
c0100bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100be0:	75 0a                	jne    c0100bec <runcmd+0x2b>
        return 0;
c0100be2:	b8 00 00 00 00       	mov    $0x0,%eax
c0100be7:	e9 83 00 00 00       	jmp    c0100c6f <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bf3:	eb 59                	jmp    c0100c4e <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bf5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bfb:	89 d0                	mov    %edx,%eax
c0100bfd:	01 c0                	add    %eax,%eax
c0100bff:	01 d0                	add    %edx,%eax
c0100c01:	c1 e0 02             	shl    $0x2,%eax
c0100c04:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c09:	8b 00                	mov    (%eax),%eax
c0100c0b:	83 ec 08             	sub    $0x8,%esp
c0100c0e:	51                   	push   %ecx
c0100c0f:	50                   	push   %eax
c0100c10:	e8 7c 44 00 00       	call   c0105091 <strcmp>
c0100c15:	83 c4 10             	add    $0x10,%esp
c0100c18:	85 c0                	test   %eax,%eax
c0100c1a:	75 2e                	jne    c0100c4a <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c1f:	89 d0                	mov    %edx,%eax
c0100c21:	01 c0                	add    %eax,%eax
c0100c23:	01 d0                	add    %edx,%eax
c0100c25:	c1 e0 02             	shl    $0x2,%eax
c0100c28:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c2d:	8b 10                	mov    (%eax),%edx
c0100c2f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c32:	83 c0 04             	add    $0x4,%eax
c0100c35:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c38:	83 e9 01             	sub    $0x1,%ecx
c0100c3b:	83 ec 04             	sub    $0x4,%esp
c0100c3e:	ff 75 0c             	pushl  0xc(%ebp)
c0100c41:	50                   	push   %eax
c0100c42:	51                   	push   %ecx
c0100c43:	ff d2                	call   *%edx
c0100c45:	83 c4 10             	add    $0x10,%esp
c0100c48:	eb 25                	jmp    c0100c6f <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c51:	83 f8 02             	cmp    $0x2,%eax
c0100c54:	76 9f                	jbe    c0100bf5 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c56:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c59:	83 ec 08             	sub    $0x8,%esp
c0100c5c:	50                   	push   %eax
c0100c5d:	68 2f 5d 10 c0       	push   $0xc0105d2f
c0100c62:	e8 05 f6 ff ff       	call   c010026c <cprintf>
c0100c67:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c6f:	c9                   	leave  
c0100c70:	c3                   	ret    

c0100c71 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c71:	55                   	push   %ebp
c0100c72:	89 e5                	mov    %esp,%ebp
c0100c74:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c77:	83 ec 0c             	sub    $0xc,%esp
c0100c7a:	68 48 5d 10 c0       	push   $0xc0105d48
c0100c7f:	e8 e8 f5 ff ff       	call   c010026c <cprintf>
c0100c84:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c87:	83 ec 0c             	sub    $0xc,%esp
c0100c8a:	68 70 5d 10 c0       	push   $0xc0105d70
c0100c8f:	e8 d8 f5 ff ff       	call   c010026c <cprintf>
c0100c94:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c9b:	74 0e                	je     c0100cab <kmonitor+0x3a>
        print_trapframe(tf);
c0100c9d:	83 ec 0c             	sub    $0xc,%esp
c0100ca0:	ff 75 08             	pushl  0x8(%ebp)
c0100ca3:	e8 c0 0d 00 00       	call   c0101a68 <print_trapframe>
c0100ca8:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cab:	83 ec 0c             	sub    $0xc,%esp
c0100cae:	68 95 5d 10 c0       	push   $0xc0105d95
c0100cb3:	e8 58 f6 ff ff       	call   c0100310 <readline>
c0100cb8:	83 c4 10             	add    $0x10,%esp
c0100cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cc2:	74 e7                	je     c0100cab <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cc4:	83 ec 08             	sub    $0x8,%esp
c0100cc7:	ff 75 08             	pushl  0x8(%ebp)
c0100cca:	ff 75 f4             	pushl  -0xc(%ebp)
c0100ccd:	e8 ef fe ff ff       	call   c0100bc1 <runcmd>
c0100cd2:	83 c4 10             	add    $0x10,%esp
c0100cd5:	85 c0                	test   %eax,%eax
c0100cd7:	78 02                	js     c0100cdb <kmonitor+0x6a>
                break;
            }
        }
    }
c0100cd9:	eb d0                	jmp    c0100cab <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cdb:	90                   	nop
            }
        }
    }
}
c0100cdc:	90                   	nop
c0100cdd:	c9                   	leave  
c0100cde:	c3                   	ret    

c0100cdf <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cdf:	55                   	push   %ebp
c0100ce0:	89 e5                	mov    %esp,%ebp
c0100ce2:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cec:	eb 3c                	jmp    c0100d2a <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cf1:	89 d0                	mov    %edx,%eax
c0100cf3:	01 c0                	add    %eax,%eax
c0100cf5:	01 d0                	add    %edx,%eax
c0100cf7:	c1 e0 02             	shl    $0x2,%eax
c0100cfa:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100cff:	8b 08                	mov    (%eax),%ecx
c0100d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d04:	89 d0                	mov    %edx,%eax
c0100d06:	01 c0                	add    %eax,%eax
c0100d08:	01 d0                	add    %edx,%eax
c0100d0a:	c1 e0 02             	shl    $0x2,%eax
c0100d0d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d12:	8b 00                	mov    (%eax),%eax
c0100d14:	83 ec 04             	sub    $0x4,%esp
c0100d17:	51                   	push   %ecx
c0100d18:	50                   	push   %eax
c0100d19:	68 99 5d 10 c0       	push   $0xc0105d99
c0100d1e:	e8 49 f5 ff ff       	call   c010026c <cprintf>
c0100d23:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d2d:	83 f8 02             	cmp    $0x2,%eax
c0100d30:	76 bc                	jbe    c0100cee <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d37:	c9                   	leave  
c0100d38:	c3                   	ret    

c0100d39 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d39:	55                   	push   %ebp
c0100d3a:	89 e5                	mov    %esp,%ebp
c0100d3c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d3f:	e8 b2 fb ff ff       	call   c01008f6 <print_kerninfo>
    return 0;
c0100d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d49:	c9                   	leave  
c0100d4a:	c3                   	ret    

c0100d4b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d4b:	55                   	push   %ebp
c0100d4c:	89 e5                	mov    %esp,%ebp
c0100d4e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d51:	e8 ea fc ff ff       	call   c0100a40 <print_stackframe>
    return 0;
c0100d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d5b:	c9                   	leave  
c0100d5c:	c3                   	ret    

c0100d5d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d5d:	55                   	push   %ebp
c0100d5e:	89 e5                	mov    %esp,%ebp
c0100d60:	83 ec 18             	sub    $0x18,%esp
c0100d63:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d69:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d6d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d71:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d75:	ee                   	out    %al,(%dx)
c0100d76:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d7c:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d80:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d84:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d88:	ee                   	out    %al,(%dx)
c0100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d8f:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d9b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d9c:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100da3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100da6:	83 ec 0c             	sub    $0xc,%esp
c0100da9:	68 a2 5d 10 c0       	push   $0xc0105da2
c0100dae:	e8 b9 f4 ff ff       	call   c010026c <cprintf>
c0100db3:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100db6:	83 ec 0c             	sub    $0xc,%esp
c0100db9:	6a 00                	push   $0x0
c0100dbb:	e8 3b 09 00 00       	call   c01016fb <pic_enable>
c0100dc0:	83 c4 10             	add    $0x10,%esp
}
c0100dc3:	90                   	nop
c0100dc4:	c9                   	leave  
c0100dc5:	c3                   	ret    

c0100dc6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dc6:	55                   	push   %ebp
c0100dc7:	89 e5                	mov    %esp,%ebp
c0100dc9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dcc:	9c                   	pushf  
c0100dcd:	58                   	pop    %eax
c0100dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dd4:	25 00 02 00 00       	and    $0x200,%eax
c0100dd9:	85 c0                	test   %eax,%eax
c0100ddb:	74 0c                	je     c0100de9 <__intr_save+0x23>
        intr_disable();
c0100ddd:	e8 8a 0a 00 00       	call   c010186c <intr_disable>
        return 1;
c0100de2:	b8 01 00 00 00       	mov    $0x1,%eax
c0100de7:	eb 05                	jmp    c0100dee <__intr_save+0x28>
    }
    return 0;
c0100de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dee:	c9                   	leave  
c0100def:	c3                   	ret    

c0100df0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100df0:	55                   	push   %ebp
c0100df1:	89 e5                	mov    %esp,%ebp
c0100df3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100dfa:	74 05                	je     c0100e01 <__intr_restore+0x11>
        intr_enable();
c0100dfc:	e8 64 0a 00 00       	call   c0101865 <intr_enable>
    }
}
c0100e01:	90                   	nop
c0100e02:	c9                   	leave  
c0100e03:	c3                   	ret    

c0100e04 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e04:	55                   	push   %ebp
c0100e05:	89 e5                	mov    %esp,%ebp
c0100e07:	83 ec 10             	sub    $0x10,%esp
c0100e0a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e14:	89 c2                	mov    %eax,%edx
c0100e16:	ec                   	in     (%dx),%al
c0100e17:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e1a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e20:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e24:	89 c2                	mov    %eax,%edx
c0100e26:	ec                   	in     (%dx),%al
c0100e27:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e2a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e30:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e34:	89 c2                	mov    %eax,%edx
c0100e36:	ec                   	in     (%dx),%al
c0100e37:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e3a:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e40:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e44:	89 c2                	mov    %eax,%edx
c0100e46:	ec                   	in     (%dx),%al
c0100e47:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e4a:	90                   	nop
c0100e4b:	c9                   	leave  
c0100e4c:	c3                   	ret    

c0100e4d <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e4d:	55                   	push   %ebp
c0100e4e:	89 e5                	mov    %esp,%ebp
c0100e50:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e53:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e5d:	0f b7 00             	movzwl (%eax),%eax
c0100e60:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e67:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e6f:	0f b7 00             	movzwl (%eax),%eax
c0100e72:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e76:	74 12                	je     c0100e8a <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e78:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e7f:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e86:	b4 03 
c0100e88:	eb 13                	jmp    c0100e9d <cga_init+0x50>
    } else {
        *cp = was;
c0100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e91:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e94:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e9b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e9d:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ea4:	0f b7 c0             	movzwl %ax,%eax
c0100ea7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100eab:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eaf:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100eb3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100eb7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eb8:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ebf:	83 c0 01             	add    $0x1,%eax
c0100ec2:	0f b7 c0             	movzwl %ax,%eax
c0100ec5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ec9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ecd:	89 c2                	mov    %eax,%edx
c0100ecf:	ec                   	in     (%dx),%al
c0100ed0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ed3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ed7:	0f b6 c0             	movzbl %al,%eax
c0100eda:	c1 e0 08             	shl    $0x8,%eax
c0100edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ee0:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee7:	0f b7 c0             	movzwl %ax,%eax
c0100eea:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100eee:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100ef6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100efa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100efb:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f02:	83 c0 01             	add    $0x1,%eax
c0100f05:	0f b7 c0             	movzwl %ax,%eax
c0100f08:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f0c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f10:	89 c2                	mov    %eax,%edx
c0100f12:	ec                   	in     (%dx),%al
c0100f13:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f16:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f1a:	0f b6 c0             	movzbl %al,%eax
c0100f1d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f23:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f2b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f31:	90                   	nop
c0100f32:	c9                   	leave  
c0100f33:	c3                   	ret    

c0100f34 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f34:	55                   	push   %ebp
c0100f35:	89 e5                	mov    %esp,%ebp
c0100f37:	83 ec 28             	sub    $0x28,%esp
c0100f3a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f40:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f44:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f48:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f4c:	ee                   	out    %al,(%dx)
c0100f4d:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f53:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f57:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f5b:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f5f:	ee                   	out    %al,(%dx)
c0100f60:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f66:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f6a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f6e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f72:	ee                   	out    %al,(%dx)
c0100f73:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f79:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f7d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f81:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f85:	ee                   	out    %al,(%dx)
c0100f86:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f8c:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f90:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f94:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f98:	ee                   	out    %al,(%dx)
c0100f99:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f9f:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100fa3:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100fa7:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100fab:	ee                   	out    %al,(%dx)
c0100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fb2:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fb6:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fbe:	ee                   	out    %al,(%dx)
c0100fbf:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fc5:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fc9:	89 c2                	mov    %eax,%edx
c0100fcb:	ec                   	in     (%dx),%al
c0100fcc:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fcf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fd3:	3c ff                	cmp    $0xff,%al
c0100fd5:	0f 95 c0             	setne  %al
c0100fd8:	0f b6 c0             	movzbl %al,%eax
c0100fdb:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fe0:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fea:	89 c2                	mov    %eax,%edx
c0100fec:	ec                   	in     (%dx),%al
c0100fed:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100ff0:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100ff6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100ffa:	89 c2                	mov    %eax,%edx
c0100ffc:	ec                   	in     (%dx),%al
c0100ffd:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101000:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101005:	85 c0                	test   %eax,%eax
c0101007:	74 0d                	je     c0101016 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101009:	83 ec 0c             	sub    $0xc,%esp
c010100c:	6a 04                	push   $0x4
c010100e:	e8 e8 06 00 00       	call   c01016fb <pic_enable>
c0101013:	83 c4 10             	add    $0x10,%esp
    }
}
c0101016:	90                   	nop
c0101017:	c9                   	leave  
c0101018:	c3                   	ret    

c0101019 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101019:	55                   	push   %ebp
c010101a:	89 e5                	mov    %esp,%ebp
c010101c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101026:	eb 09                	jmp    c0101031 <lpt_putc_sub+0x18>
        delay();
c0101028:	e8 d7 fd ff ff       	call   c0100e04 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010102d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101031:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101037:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010103b:	89 c2                	mov    %eax,%edx
c010103d:	ec                   	in     (%dx),%al
c010103e:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0101041:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101045:	84 c0                	test   %al,%al
c0101047:	78 09                	js     c0101052 <lpt_putc_sub+0x39>
c0101049:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101050:	7e d6                	jle    c0101028 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101052:	8b 45 08             	mov    0x8(%ebp),%eax
c0101055:	0f b6 c0             	movzbl %al,%eax
c0101058:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c010105e:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101061:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0101065:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101069:	ee                   	out    %al,(%dx)
c010106a:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101070:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101074:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101078:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010107c:	ee                   	out    %al,(%dx)
c010107d:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0101083:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c0101087:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c010108b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010108f:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101090:	90                   	nop
c0101091:	c9                   	leave  
c0101092:	c3                   	ret    

c0101093 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101093:	55                   	push   %ebp
c0101094:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101096:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010109a:	74 0d                	je     c01010a9 <lpt_putc+0x16>
        lpt_putc_sub(c);
c010109c:	ff 75 08             	pushl  0x8(%ebp)
c010109f:	e8 75 ff ff ff       	call   c0101019 <lpt_putc_sub>
c01010a4:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010a7:	eb 1e                	jmp    c01010c7 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c01010a9:	6a 08                	push   $0x8
c01010ab:	e8 69 ff ff ff       	call   c0101019 <lpt_putc_sub>
c01010b0:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010b3:	6a 20                	push   $0x20
c01010b5:	e8 5f ff ff ff       	call   c0101019 <lpt_putc_sub>
c01010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010bd:	6a 08                	push   $0x8
c01010bf:	e8 55 ff ff ff       	call   c0101019 <lpt_putc_sub>
c01010c4:	83 c4 04             	add    $0x4,%esp
    }
}
c01010c7:	90                   	nop
c01010c8:	c9                   	leave  
c01010c9:	c3                   	ret    

c01010ca <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010ca:	55                   	push   %ebp
c01010cb:	89 e5                	mov    %esp,%ebp
c01010cd:	53                   	push   %ebx
c01010ce:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d4:	b0 00                	mov    $0x0,%al
c01010d6:	85 c0                	test   %eax,%eax
c01010d8:	75 07                	jne    c01010e1 <cga_putc+0x17>
        c |= 0x0700;
c01010da:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e4:	0f b6 c0             	movzbl %al,%eax
c01010e7:	83 f8 0a             	cmp    $0xa,%eax
c01010ea:	74 4e                	je     c010113a <cga_putc+0x70>
c01010ec:	83 f8 0d             	cmp    $0xd,%eax
c01010ef:	74 59                	je     c010114a <cga_putc+0x80>
c01010f1:	83 f8 08             	cmp    $0x8,%eax
c01010f4:	0f 85 8a 00 00 00    	jne    c0101184 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010fa:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101101:	66 85 c0             	test   %ax,%ax
c0101104:	0f 84 a0 00 00 00    	je     c01011aa <cga_putc+0xe0>
            crt_pos --;
c010110a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101111:	83 e8 01             	sub    $0x1,%eax
c0101114:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010111a:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010111f:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101126:	0f b7 d2             	movzwl %dx,%edx
c0101129:	01 d2                	add    %edx,%edx
c010112b:	01 d0                	add    %edx,%eax
c010112d:	8b 55 08             	mov    0x8(%ebp),%edx
c0101130:	b2 00                	mov    $0x0,%dl
c0101132:	83 ca 20             	or     $0x20,%edx
c0101135:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101138:	eb 70                	jmp    c01011aa <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c010113a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101141:	83 c0 50             	add    $0x50,%eax
c0101144:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010114a:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101151:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101158:	0f b7 c1             	movzwl %cx,%eax
c010115b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101161:	c1 e8 10             	shr    $0x10,%eax
c0101164:	89 c2                	mov    %eax,%edx
c0101166:	66 c1 ea 06          	shr    $0x6,%dx
c010116a:	89 d0                	mov    %edx,%eax
c010116c:	c1 e0 02             	shl    $0x2,%eax
c010116f:	01 d0                	add    %edx,%eax
c0101171:	c1 e0 04             	shl    $0x4,%eax
c0101174:	29 c1                	sub    %eax,%ecx
c0101176:	89 ca                	mov    %ecx,%edx
c0101178:	89 d8                	mov    %ebx,%eax
c010117a:	29 d0                	sub    %edx,%eax
c010117c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101182:	eb 27                	jmp    c01011ab <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101184:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c010118a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101191:	8d 50 01             	lea    0x1(%eax),%edx
c0101194:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c010119b:	0f b7 c0             	movzwl %ax,%eax
c010119e:	01 c0                	add    %eax,%eax
c01011a0:	01 c8                	add    %ecx,%eax
c01011a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01011a5:	66 89 10             	mov    %dx,(%eax)
        break;
c01011a8:	eb 01                	jmp    c01011ab <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c01011aa:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ab:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b2:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011b6:	76 59                	jbe    c0101211 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011b8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011bd:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011c3:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011c8:	83 ec 04             	sub    $0x4,%esp
c01011cb:	68 00 0f 00 00       	push   $0xf00
c01011d0:	52                   	push   %edx
c01011d1:	50                   	push   %eax
c01011d2:	e8 59 41 00 00       	call   c0105330 <memmove>
c01011d7:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011da:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011e1:	eb 15                	jmp    c01011f8 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011e3:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011eb:	01 d2                	add    %edx,%edx
c01011ed:	01 d0                	add    %edx,%eax
c01011ef:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011f8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011ff:	7e e2                	jle    c01011e3 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101201:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101208:	83 e8 50             	sub    $0x50,%eax
c010120b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101211:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101218:	0f b7 c0             	movzwl %ax,%eax
c010121b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010121f:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c0101223:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101227:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010122b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010122c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101233:	66 c1 e8 08          	shr    $0x8,%ax
c0101237:	0f b6 c0             	movzbl %al,%eax
c010123a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101241:	83 c2 01             	add    $0x1,%edx
c0101244:	0f b7 d2             	movzwl %dx,%edx
c0101247:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c010124b:	88 45 e9             	mov    %al,-0x17(%ebp)
c010124e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101252:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101256:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101257:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010125e:	0f b7 c0             	movzwl %ax,%eax
c0101261:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101265:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101269:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c010126d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101271:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101272:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101279:	0f b6 c0             	movzbl %al,%eax
c010127c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101283:	83 c2 01             	add    $0x1,%edx
c0101286:	0f b7 d2             	movzwl %dx,%edx
c0101289:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c010128d:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101290:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101294:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101298:	ee                   	out    %al,(%dx)
}
c0101299:	90                   	nop
c010129a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010129d:	c9                   	leave  
c010129e:	c3                   	ret    

c010129f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010129f:	55                   	push   %ebp
c01012a0:	89 e5                	mov    %esp,%ebp
c01012a2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012ac:	eb 09                	jmp    c01012b7 <serial_putc_sub+0x18>
        delay();
c01012ae:	e8 51 fb ff ff       	call   c0100e04 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012b7:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012bd:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012c1:	89 c2                	mov    %eax,%edx
c01012c3:	ec                   	in     (%dx),%al
c01012c4:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012c7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012cb:	0f b6 c0             	movzbl %al,%eax
c01012ce:	83 e0 20             	and    $0x20,%eax
c01012d1:	85 c0                	test   %eax,%eax
c01012d3:	75 09                	jne    c01012de <serial_putc_sub+0x3f>
c01012d5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012dc:	7e d0                	jle    c01012ae <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012de:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e1:	0f b6 c0             	movzbl %al,%eax
c01012e4:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012ea:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012ed:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012f1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012f5:	ee                   	out    %al,(%dx)
}
c01012f6:	90                   	nop
c01012f7:	c9                   	leave  
c01012f8:	c3                   	ret    

c01012f9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012f9:	55                   	push   %ebp
c01012fa:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012fc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101300:	74 0d                	je     c010130f <serial_putc+0x16>
        serial_putc_sub(c);
c0101302:	ff 75 08             	pushl  0x8(%ebp)
c0101305:	e8 95 ff ff ff       	call   c010129f <serial_putc_sub>
c010130a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c010130d:	eb 1e                	jmp    c010132d <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c010130f:	6a 08                	push   $0x8
c0101311:	e8 89 ff ff ff       	call   c010129f <serial_putc_sub>
c0101316:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101319:	6a 20                	push   $0x20
c010131b:	e8 7f ff ff ff       	call   c010129f <serial_putc_sub>
c0101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c0101323:	6a 08                	push   $0x8
c0101325:	e8 75 ff ff ff       	call   c010129f <serial_putc_sub>
c010132a:	83 c4 04             	add    $0x4,%esp
    }
}
c010132d:	90                   	nop
c010132e:	c9                   	leave  
c010132f:	c3                   	ret    

c0101330 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101330:	55                   	push   %ebp
c0101331:	89 e5                	mov    %esp,%ebp
c0101333:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101336:	eb 33                	jmp    c010136b <cons_intr+0x3b>
        if (c != 0) {
c0101338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010133c:	74 2d                	je     c010136b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010133e:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101343:	8d 50 01             	lea    0x1(%eax),%edx
c0101346:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010134c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010134f:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101355:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010135a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010135f:	75 0a                	jne    c010136b <cons_intr+0x3b>
                cons.wpos = 0;
c0101361:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101368:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010136b:	8b 45 08             	mov    0x8(%ebp),%eax
c010136e:	ff d0                	call   *%eax
c0101370:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101373:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101377:	75 bf                	jne    c0101338 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101379:	90                   	nop
c010137a:	c9                   	leave  
c010137b:	c3                   	ret    

c010137c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010137c:	55                   	push   %ebp
c010137d:	89 e5                	mov    %esp,%ebp
c010137f:	83 ec 10             	sub    $0x10,%esp
c0101382:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101388:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c010138c:	89 c2                	mov    %eax,%edx
c010138e:	ec                   	in     (%dx),%al
c010138f:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c0101392:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101396:	0f b6 c0             	movzbl %al,%eax
c0101399:	83 e0 01             	and    $0x1,%eax
c010139c:	85 c0                	test   %eax,%eax
c010139e:	75 07                	jne    c01013a7 <serial_proc_data+0x2b>
        return -1;
c01013a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013a5:	eb 2a                	jmp    c01013d1 <serial_proc_data+0x55>
c01013a7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ad:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b1:	89 c2                	mov    %eax,%edx
c01013b3:	ec                   	in     (%dx),%al
c01013b4:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013b7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013bb:	0f b6 c0             	movzbl %al,%eax
c01013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013c1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013c5:	75 07                	jne    c01013ce <serial_proc_data+0x52>
        c = '\b';
c01013c7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013d1:	c9                   	leave  
c01013d2:	c3                   	ret    

c01013d3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013d3:	55                   	push   %ebp
c01013d4:	89 e5                	mov    %esp,%ebp
c01013d6:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013d9:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013de:	85 c0                	test   %eax,%eax
c01013e0:	74 10                	je     c01013f2 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013e2:	83 ec 0c             	sub    $0xc,%esp
c01013e5:	68 7c 13 10 c0       	push   $0xc010137c
c01013ea:	e8 41 ff ff ff       	call   c0101330 <cons_intr>
c01013ef:	83 c4 10             	add    $0x10,%esp
    }
}
c01013f2:	90                   	nop
c01013f3:	c9                   	leave  
c01013f4:	c3                   	ret    

c01013f5 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013f5:	55                   	push   %ebp
c01013f6:	89 e5                	mov    %esp,%ebp
c01013f8:	83 ec 18             	sub    $0x18,%esp
c01013fb:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101401:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101405:	89 c2                	mov    %eax,%edx
c0101407:	ec                   	in     (%dx),%al
c0101408:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010140b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010140f:	0f b6 c0             	movzbl %al,%eax
c0101412:	83 e0 01             	and    $0x1,%eax
c0101415:	85 c0                	test   %eax,%eax
c0101417:	75 0a                	jne    c0101423 <kbd_proc_data+0x2e>
        return -1;
c0101419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010141e:	e9 5d 01 00 00       	jmp    c0101580 <kbd_proc_data+0x18b>
c0101423:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142d:	89 c2                	mov    %eax,%edx
c010142f:	ec                   	in     (%dx),%al
c0101430:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c0101433:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101437:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010143a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010143e:	75 17                	jne    c0101457 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101440:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101445:	83 c8 40             	or     $0x40,%eax
c0101448:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010144d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101452:	e9 29 01 00 00       	jmp    c0101580 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010145b:	84 c0                	test   %al,%al
c010145d:	79 47                	jns    c01014a6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010145f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101464:	83 e0 40             	and    $0x40,%eax
c0101467:	85 c0                	test   %eax,%eax
c0101469:	75 09                	jne    c0101474 <kbd_proc_data+0x7f>
c010146b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010146f:	83 e0 7f             	and    $0x7f,%eax
c0101472:	eb 04                	jmp    c0101478 <kbd_proc_data+0x83>
c0101474:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101478:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147f:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101486:	83 c8 40             	or     $0x40,%eax
c0101489:	0f b6 c0             	movzbl %al,%eax
c010148c:	f7 d0                	not    %eax
c010148e:	89 c2                	mov    %eax,%edx
c0101490:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101495:	21 d0                	and    %edx,%eax
c0101497:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010149c:	b8 00 00 00 00       	mov    $0x0,%eax
c01014a1:	e9 da 00 00 00       	jmp    c0101580 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014a6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ab:	83 e0 40             	and    $0x40,%eax
c01014ae:	85 c0                	test   %eax,%eax
c01014b0:	74 11                	je     c01014c3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014b2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014b6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bb:	83 e0 bf             	and    $0xffffffbf,%eax
c01014be:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c7:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ce:	0f b6 d0             	movzbl %al,%edx
c01014d1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d6:	09 d0                	or     %edx,%eax
c01014d8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e1:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014e8:	0f b6 d0             	movzbl %al,%edx
c01014eb:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f0:	31 d0                	xor    %edx,%eax
c01014f2:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014f7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fc:	83 e0 03             	and    $0x3,%eax
c01014ff:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101506:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150a:	01 d0                	add    %edx,%eax
c010150c:	0f b6 00             	movzbl (%eax),%eax
c010150f:	0f b6 c0             	movzbl %al,%eax
c0101512:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101515:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151a:	83 e0 08             	and    $0x8,%eax
c010151d:	85 c0                	test   %eax,%eax
c010151f:	74 22                	je     c0101543 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101521:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101525:	7e 0c                	jle    c0101533 <kbd_proc_data+0x13e>
c0101527:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010152b:	7f 06                	jg     c0101533 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010152d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101531:	eb 10                	jmp    c0101543 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101533:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101537:	7e 0a                	jle    c0101543 <kbd_proc_data+0x14e>
c0101539:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010153d:	7f 04                	jg     c0101543 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010153f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101543:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101548:	f7 d0                	not    %eax
c010154a:	83 e0 06             	and    $0x6,%eax
c010154d:	85 c0                	test   %eax,%eax
c010154f:	75 2c                	jne    c010157d <kbd_proc_data+0x188>
c0101551:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101558:	75 23                	jne    c010157d <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c010155a:	83 ec 0c             	sub    $0xc,%esp
c010155d:	68 bd 5d 10 c0       	push   $0xc0105dbd
c0101562:	e8 05 ed ff ff       	call   c010026c <cprintf>
c0101567:	83 c4 10             	add    $0x10,%esp
c010156a:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c0101570:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101574:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101578:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010157c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101580:	c9                   	leave  
c0101581:	c3                   	ret    

c0101582 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101582:	55                   	push   %ebp
c0101583:	89 e5                	mov    %esp,%ebp
c0101585:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101588:	83 ec 0c             	sub    $0xc,%esp
c010158b:	68 f5 13 10 c0       	push   $0xc01013f5
c0101590:	e8 9b fd ff ff       	call   c0101330 <cons_intr>
c0101595:	83 c4 10             	add    $0x10,%esp
}
c0101598:	90                   	nop
c0101599:	c9                   	leave  
c010159a:	c3                   	ret    

c010159b <kbd_init>:

static void
kbd_init(void) {
c010159b:	55                   	push   %ebp
c010159c:	89 e5                	mov    %esp,%ebp
c010159e:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015a1:	e8 dc ff ff ff       	call   c0101582 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015a6:	83 ec 0c             	sub    $0xc,%esp
c01015a9:	6a 01                	push   $0x1
c01015ab:	e8 4b 01 00 00       	call   c01016fb <pic_enable>
c01015b0:	83 c4 10             	add    $0x10,%esp
}
c01015b3:	90                   	nop
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015bc:	e8 8c f8 ff ff       	call   c0100e4d <cga_init>
    serial_init();
c01015c1:	e8 6e f9 ff ff       	call   c0100f34 <serial_init>
    kbd_init();
c01015c6:	e8 d0 ff ff ff       	call   c010159b <kbd_init>
    if (!serial_exists) {
c01015cb:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015d0:	85 c0                	test   %eax,%eax
c01015d2:	75 10                	jne    c01015e4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015d4:	83 ec 0c             	sub    $0xc,%esp
c01015d7:	68 c9 5d 10 c0       	push   $0xc0105dc9
c01015dc:	e8 8b ec ff ff       	call   c010026c <cprintf>
c01015e1:	83 c4 10             	add    $0x10,%esp
    }
}
c01015e4:	90                   	nop
c01015e5:	c9                   	leave  
c01015e6:	c3                   	ret    

c01015e7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015e7:	55                   	push   %ebp
c01015e8:	89 e5                	mov    %esp,%ebp
c01015ea:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015ed:	e8 d4 f7 ff ff       	call   c0100dc6 <__intr_save>
c01015f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015f5:	83 ec 0c             	sub    $0xc,%esp
c01015f8:	ff 75 08             	pushl  0x8(%ebp)
c01015fb:	e8 93 fa ff ff       	call   c0101093 <lpt_putc>
c0101600:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c0101603:	83 ec 0c             	sub    $0xc,%esp
c0101606:	ff 75 08             	pushl  0x8(%ebp)
c0101609:	e8 bc fa ff ff       	call   c01010ca <cga_putc>
c010160e:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c0101611:	83 ec 0c             	sub    $0xc,%esp
c0101614:	ff 75 08             	pushl  0x8(%ebp)
c0101617:	e8 dd fc ff ff       	call   c01012f9 <serial_putc>
c010161c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010161f:	83 ec 0c             	sub    $0xc,%esp
c0101622:	ff 75 f4             	pushl  -0xc(%ebp)
c0101625:	e8 c6 f7 ff ff       	call   c0100df0 <__intr_restore>
c010162a:	83 c4 10             	add    $0x10,%esp
}
c010162d:	90                   	nop
c010162e:	c9                   	leave  
c010162f:	c3                   	ret    

c0101630 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101630:	55                   	push   %ebp
c0101631:	89 e5                	mov    %esp,%ebp
c0101633:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010163d:	e8 84 f7 ff ff       	call   c0100dc6 <__intr_save>
c0101642:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101645:	e8 89 fd ff ff       	call   c01013d3 <serial_intr>
        kbd_intr();
c010164a:	e8 33 ff ff ff       	call   c0101582 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010164f:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101655:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165a:	39 c2                	cmp    %eax,%edx
c010165c:	74 31                	je     c010168f <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010165e:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101663:	8d 50 01             	lea    0x1(%eax),%edx
c0101666:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010166c:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101673:	0f b6 c0             	movzbl %al,%eax
c0101676:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101679:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010167e:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101683:	75 0a                	jne    c010168f <cons_getc+0x5f>
                cons.rpos = 0;
c0101685:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010168c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010168f:	83 ec 0c             	sub    $0xc,%esp
c0101692:	ff 75 f0             	pushl  -0x10(%ebp)
c0101695:	e8 56 f7 ff ff       	call   c0100df0 <__intr_restore>
c010169a:	83 c4 10             	add    $0x10,%esp
    return c;
c010169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a0:	c9                   	leave  
c01016a1:	c3                   	ret    

c01016a2 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016a2:	55                   	push   %ebp
c01016a3:	89 e5                	mov    %esp,%ebp
c01016a5:	83 ec 14             	sub    $0x14,%esp
c01016a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ab:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016af:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016b3:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016b9:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016be:	85 c0                	test   %eax,%eax
c01016c0:	74 36                	je     c01016f8 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c6:	0f b6 c0             	movzbl %al,%eax
c01016c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016cf:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016d2:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016d6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016da:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016db:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016df:	66 c1 e8 08          	shr    $0x8,%ax
c01016e3:	0f b6 c0             	movzbl %al,%eax
c01016e6:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016ec:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016ef:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016f3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016f7:	ee                   	out    %al,(%dx)
    }
}
c01016f8:	90                   	nop
c01016f9:	c9                   	leave  
c01016fa:	c3                   	ret    

c01016fb <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016fb:	55                   	push   %ebp
c01016fc:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101701:	ba 01 00 00 00       	mov    $0x1,%edx
c0101706:	89 c1                	mov    %eax,%ecx
c0101708:	d3 e2                	shl    %cl,%edx
c010170a:	89 d0                	mov    %edx,%eax
c010170c:	f7 d0                	not    %eax
c010170e:	89 c2                	mov    %eax,%edx
c0101710:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101717:	21 d0                	and    %edx,%eax
c0101719:	0f b7 c0             	movzwl %ax,%eax
c010171c:	50                   	push   %eax
c010171d:	e8 80 ff ff ff       	call   c01016a2 <pic_setmask>
c0101722:	83 c4 04             	add    $0x4,%esp
}
c0101725:	90                   	nop
c0101726:	c9                   	leave  
c0101727:	c3                   	ret    

c0101728 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
c010172b:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c010172e:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101735:	00 00 00 
c0101738:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010173e:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c0101742:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101746:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010174a:	ee                   	out    %al,(%dx)
c010174b:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101751:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101755:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101759:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c010175d:	ee                   	out    %al,(%dx)
c010175e:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c0101764:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101768:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c010176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101770:	ee                   	out    %al,(%dx)
c0101771:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101777:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c010177b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010177f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101783:	ee                   	out    %al,(%dx)
c0101784:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c010178a:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c010178e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0101792:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
c0101797:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c010179d:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01017a1:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017a5:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
c01017aa:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017b0:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017b4:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017b8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017bc:	ee                   	out    %al,(%dx)
c01017bd:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017c3:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017c7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017cb:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017cf:	ee                   	out    %al,(%dx)
c01017d0:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017d6:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017da:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017de:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017e2:	ee                   	out    %al,(%dx)
c01017e3:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017e9:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017ed:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017f1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017f5:	ee                   	out    %al,(%dx)
c01017f6:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017fc:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c0101800:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0101804:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101808:	ee                   	out    %al,(%dx)
c0101809:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c010180f:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c0101813:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101817:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010181b:	ee                   	out    %al,(%dx)
c010181c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101822:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101826:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c010182a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
c010182f:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c0101835:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0101839:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c010183d:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101842:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101849:	66 83 f8 ff          	cmp    $0xffff,%ax
c010184d:	74 13                	je     c0101862 <pic_init+0x13a>
        pic_setmask(irq_mask);
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	0f b7 c0             	movzwl %ax,%eax
c0101859:	50                   	push   %eax
c010185a:	e8 43 fe ff ff       	call   c01016a2 <pic_setmask>
c010185f:	83 c4 04             	add    $0x4,%esp
    }
}
c0101862:	90                   	nop
c0101863:	c9                   	leave  
c0101864:	c3                   	ret    

c0101865 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101865:	55                   	push   %ebp
c0101866:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101868:	fb                   	sti    
    sti();
}
c0101869:	90                   	nop
c010186a:	5d                   	pop    %ebp
c010186b:	c3                   	ret    

c010186c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010186c:	55                   	push   %ebp
c010186d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c010186f:	fa                   	cli    
    cli();
}
c0101870:	90                   	nop
c0101871:	5d                   	pop    %ebp
c0101872:	c3                   	ret    

c0101873 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101873:	55                   	push   %ebp
c0101874:	89 e5                	mov    %esp,%ebp
c0101876:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101879:	83 ec 08             	sub    $0x8,%esp
c010187c:	6a 64                	push   $0x64
c010187e:	68 00 5e 10 c0       	push   $0xc0105e00
c0101883:	e8 e4 e9 ff ff       	call   c010026c <cprintf>
c0101888:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188b:	83 ec 0c             	sub    $0xc,%esp
c010188e:	68 0a 5e 10 c0       	push   $0xc0105e0a
c0101893:	e8 d4 e9 ff ff       	call   c010026c <cprintf>
c0101898:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c010189b:	83 ec 04             	sub    $0x4,%esp
c010189e:	68 18 5e 10 c0       	push   $0xc0105e18
c01018a3:	6a 12                	push   $0x12
c01018a5:	68 2e 5e 10 c0       	push   $0xc0105e2e
c01018aa:	e8 23 eb ff ff       	call   c01003d2 <__panic>

c01018af <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018af:	55                   	push   %ebp
c01018b0:	89 e5                	mov    %esp,%ebp
c01018b2:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018bc:	e9 c3 00 00 00       	jmp    c0101984 <idt_init+0xd5>
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c4:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018cb:	89 c2                	mov    %eax,%edx
c01018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d0:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018d7:	c0 
c01018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018db:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018e2:	c0 08 00 
c01018e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e8:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018ef:	c0 
c01018f0:	83 e2 e0             	and    $0xffffffe0,%edx
c01018f3:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fd:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101904:	c0 
c0101905:	83 e2 1f             	and    $0x1f,%edx
c0101908:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101912:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101919:	c0 
c010191a:	83 e2 f0             	and    $0xfffffff0,%edx
c010191d:	83 ca 0e             	or     $0xe,%edx
c0101920:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192a:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101931:	c0 
c0101932:	83 e2 ef             	and    $0xffffffef,%edx
c0101935:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193f:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101946:	c0 
c0101947:	83 e2 9f             	and    $0xffffff9f,%edx
c010194a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101951:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101954:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195b:	c0 
c010195c:	83 ca 80             	or     $0xffffff80,%edx
c010195f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101966:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101969:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101970:	c1 e8 10             	shr    $0x10,%eax
c0101973:	89 c2                	mov    %eax,%edx
c0101975:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101978:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010197f:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101980:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	3d ff 00 00 00       	cmp    $0xff,%eax
c010198c:	0f 86 2f ff ff ff    	jbe    c01018c1 <idt_init+0x12>
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        // set for switch from user to kernel
        SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101992:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101997:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010199d:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019a4:	08 00 
c01019a6:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019ad:	83 e0 e0             	and    $0xffffffe0,%eax
c01019b0:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019b5:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019bc:	83 e0 1f             	and    $0x1f,%eax
c01019bf:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019c4:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019cb:	83 e0 f0             	and    $0xfffffff0,%eax
c01019ce:	83 c8 0e             	or     $0xe,%eax
c01019d1:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d6:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019dd:	83 e0 ef             	and    $0xffffffef,%eax
c01019e0:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ec:	83 c8 60             	or     $0x60,%eax
c01019ef:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019f4:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019fb:	83 c8 80             	or     $0xffffff80,%eax
c01019fe:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a03:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a08:	c1 e8 10             	shr    $0x10,%eax
c0101a0b:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a11:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a1b:	0f 01 18             	lidtl  (%eax)
        // load the IDT
        lidt(&idt_pd);
}
c0101a1e:	90                   	nop
c0101a1f:	c9                   	leave  
c0101a20:	c3                   	ret    

c0101a21 <trapname>:

static const char *
trapname(int trapno) {
c0101a21:	55                   	push   %ebp
c0101a22:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a27:	83 f8 13             	cmp    $0x13,%eax
c0101a2a:	77 0c                	ja     c0101a38 <trapname+0x17>
        return excnames[trapno];
c0101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2f:	8b 04 85 80 61 10 c0 	mov    -0x3fef9e80(,%eax,4),%eax
c0101a36:	eb 18                	jmp    c0101a50 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a38:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a3c:	7e 0d                	jle    c0101a4b <trapname+0x2a>
c0101a3e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a42:	7f 07                	jg     c0101a4b <trapname+0x2a>
        return "Hardware Interrupt";
c0101a44:	b8 3f 5e 10 c0       	mov    $0xc0105e3f,%eax
c0101a49:	eb 05                	jmp    c0101a50 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a4b:	b8 52 5e 10 c0       	mov    $0xc0105e52,%eax
}
c0101a50:	5d                   	pop    %ebp
c0101a51:	c3                   	ret    

c0101a52 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a52:	55                   	push   %ebp
c0101a53:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a5c:	66 83 f8 08          	cmp    $0x8,%ax
c0101a60:	0f 94 c0             	sete   %al
c0101a63:	0f b6 c0             	movzbl %al,%eax
}
c0101a66:	5d                   	pop    %ebp
c0101a67:	c3                   	ret    

c0101a68 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a68:	55                   	push   %ebp
c0101a69:	89 e5                	mov    %esp,%ebp
c0101a6b:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a6e:	83 ec 08             	sub    $0x8,%esp
c0101a71:	ff 75 08             	pushl  0x8(%ebp)
c0101a74:	68 93 5e 10 c0       	push   $0xc0105e93
c0101a79:	e8 ee e7 ff ff       	call   c010026c <cprintf>
c0101a7e:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a84:	83 ec 0c             	sub    $0xc,%esp
c0101a87:	50                   	push   %eax
c0101a88:	e8 b8 01 00 00       	call   c0101c45 <print_regs>
c0101a8d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a93:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a97:	0f b7 c0             	movzwl %ax,%eax
c0101a9a:	83 ec 08             	sub    $0x8,%esp
c0101a9d:	50                   	push   %eax
c0101a9e:	68 a4 5e 10 c0       	push   $0xc0105ea4
c0101aa3:	e8 c4 e7 ff ff       	call   c010026c <cprintf>
c0101aa8:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ab2:	0f b7 c0             	movzwl %ax,%eax
c0101ab5:	83 ec 08             	sub    $0x8,%esp
c0101ab8:	50                   	push   %eax
c0101ab9:	68 b7 5e 10 c0       	push   $0xc0105eb7
c0101abe:	e8 a9 e7 ff ff       	call   c010026c <cprintf>
c0101ac3:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101acd:	0f b7 c0             	movzwl %ax,%eax
c0101ad0:	83 ec 08             	sub    $0x8,%esp
c0101ad3:	50                   	push   %eax
c0101ad4:	68 ca 5e 10 c0       	push   $0xc0105eca
c0101ad9:	e8 8e e7 ff ff       	call   c010026c <cprintf>
c0101ade:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ae8:	0f b7 c0             	movzwl %ax,%eax
c0101aeb:	83 ec 08             	sub    $0x8,%esp
c0101aee:	50                   	push   %eax
c0101aef:	68 dd 5e 10 c0       	push   $0xc0105edd
c0101af4:	e8 73 e7 ff ff       	call   c010026c <cprintf>
c0101af9:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	8b 40 30             	mov    0x30(%eax),%eax
c0101b02:	83 ec 0c             	sub    $0xc,%esp
c0101b05:	50                   	push   %eax
c0101b06:	e8 16 ff ff ff       	call   c0101a21 <trapname>
c0101b0b:	83 c4 10             	add    $0x10,%esp
c0101b0e:	89 c2                	mov    %eax,%edx
c0101b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b13:	8b 40 30             	mov    0x30(%eax),%eax
c0101b16:	83 ec 04             	sub    $0x4,%esp
c0101b19:	52                   	push   %edx
c0101b1a:	50                   	push   %eax
c0101b1b:	68 f0 5e 10 c0       	push   $0xc0105ef0
c0101b20:	e8 47 e7 ff ff       	call   c010026c <cprintf>
c0101b25:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2b:	8b 40 34             	mov    0x34(%eax),%eax
c0101b2e:	83 ec 08             	sub    $0x8,%esp
c0101b31:	50                   	push   %eax
c0101b32:	68 02 5f 10 c0       	push   $0xc0105f02
c0101b37:	e8 30 e7 ff ff       	call   c010026c <cprintf>
c0101b3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b42:	8b 40 38             	mov    0x38(%eax),%eax
c0101b45:	83 ec 08             	sub    $0x8,%esp
c0101b48:	50                   	push   %eax
c0101b49:	68 11 5f 10 c0       	push   $0xc0105f11
c0101b4e:	e8 19 e7 ff ff       	call   c010026c <cprintf>
c0101b53:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b59:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b5d:	0f b7 c0             	movzwl %ax,%eax
c0101b60:	83 ec 08             	sub    $0x8,%esp
c0101b63:	50                   	push   %eax
c0101b64:	68 20 5f 10 c0       	push   $0xc0105f20
c0101b69:	e8 fe e6 ff ff       	call   c010026c <cprintf>
c0101b6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b74:	8b 40 40             	mov    0x40(%eax),%eax
c0101b77:	83 ec 08             	sub    $0x8,%esp
c0101b7a:	50                   	push   %eax
c0101b7b:	68 33 5f 10 c0       	push   $0xc0105f33
c0101b80:	e8 e7 e6 ff ff       	call   c010026c <cprintf>
c0101b85:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b8f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b96:	eb 3f                	jmp    c0101bd7 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9b:	8b 50 40             	mov    0x40(%eax),%edx
c0101b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ba1:	21 d0                	and    %edx,%eax
c0101ba3:	85 c0                	test   %eax,%eax
c0101ba5:	74 29                	je     c0101bd0 <print_trapframe+0x168>
c0101ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101baa:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bb1:	85 c0                	test   %eax,%eax
c0101bb3:	74 1b                	je     c0101bd0 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb8:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bbf:	83 ec 08             	sub    $0x8,%esp
c0101bc2:	50                   	push   %eax
c0101bc3:	68 42 5f 10 c0       	push   $0xc0105f42
c0101bc8:	e8 9f e6 ff ff       	call   c010026c <cprintf>
c0101bcd:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bd4:	d1 65 f0             	shll   -0x10(%ebp)
c0101bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bda:	83 f8 17             	cmp    $0x17,%eax
c0101bdd:	76 b9                	jbe    c0101b98 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be2:	8b 40 40             	mov    0x40(%eax),%eax
c0101be5:	25 00 30 00 00       	and    $0x3000,%eax
c0101bea:	c1 e8 0c             	shr    $0xc,%eax
c0101bed:	83 ec 08             	sub    $0x8,%esp
c0101bf0:	50                   	push   %eax
c0101bf1:	68 46 5f 10 c0       	push   $0xc0105f46
c0101bf6:	e8 71 e6 ff ff       	call   c010026c <cprintf>
c0101bfb:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bfe:	83 ec 0c             	sub    $0xc,%esp
c0101c01:	ff 75 08             	pushl  0x8(%ebp)
c0101c04:	e8 49 fe ff ff       	call   c0101a52 <trap_in_kernel>
c0101c09:	83 c4 10             	add    $0x10,%esp
c0101c0c:	85 c0                	test   %eax,%eax
c0101c0e:	75 32                	jne    c0101c42 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c13:	8b 40 44             	mov    0x44(%eax),%eax
c0101c16:	83 ec 08             	sub    $0x8,%esp
c0101c19:	50                   	push   %eax
c0101c1a:	68 4f 5f 10 c0       	push   $0xc0105f4f
c0101c1f:	e8 48 e6 ff ff       	call   c010026c <cprintf>
c0101c24:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c2e:	0f b7 c0             	movzwl %ax,%eax
c0101c31:	83 ec 08             	sub    $0x8,%esp
c0101c34:	50                   	push   %eax
c0101c35:	68 5e 5f 10 c0       	push   $0xc0105f5e
c0101c3a:	e8 2d e6 ff ff       	call   c010026c <cprintf>
c0101c3f:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c42:	90                   	nop
c0101c43:	c9                   	leave  
c0101c44:	c3                   	ret    

c0101c45 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c45:	55                   	push   %ebp
c0101c46:	89 e5                	mov    %esp,%ebp
c0101c48:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4e:	8b 00                	mov    (%eax),%eax
c0101c50:	83 ec 08             	sub    $0x8,%esp
c0101c53:	50                   	push   %eax
c0101c54:	68 71 5f 10 c0       	push   $0xc0105f71
c0101c59:	e8 0e e6 ff ff       	call   c010026c <cprintf>
c0101c5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c64:	8b 40 04             	mov    0x4(%eax),%eax
c0101c67:	83 ec 08             	sub    $0x8,%esp
c0101c6a:	50                   	push   %eax
c0101c6b:	68 80 5f 10 c0       	push   $0xc0105f80
c0101c70:	e8 f7 e5 ff ff       	call   c010026c <cprintf>
c0101c75:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c7e:	83 ec 08             	sub    $0x8,%esp
c0101c81:	50                   	push   %eax
c0101c82:	68 8f 5f 10 c0       	push   $0xc0105f8f
c0101c87:	e8 e0 e5 ff ff       	call   c010026c <cprintf>
c0101c8c:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c92:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c95:	83 ec 08             	sub    $0x8,%esp
c0101c98:	50                   	push   %eax
c0101c99:	68 9e 5f 10 c0       	push   $0xc0105f9e
c0101c9e:	e8 c9 e5 ff ff       	call   c010026c <cprintf>
c0101ca3:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca9:	8b 40 10             	mov    0x10(%eax),%eax
c0101cac:	83 ec 08             	sub    $0x8,%esp
c0101caf:	50                   	push   %eax
c0101cb0:	68 ad 5f 10 c0       	push   $0xc0105fad
c0101cb5:	e8 b2 e5 ff ff       	call   c010026c <cprintf>
c0101cba:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc0:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc3:	83 ec 08             	sub    $0x8,%esp
c0101cc6:	50                   	push   %eax
c0101cc7:	68 bc 5f 10 c0       	push   $0xc0105fbc
c0101ccc:	e8 9b e5 ff ff       	call   c010026c <cprintf>
c0101cd1:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd7:	8b 40 18             	mov    0x18(%eax),%eax
c0101cda:	83 ec 08             	sub    $0x8,%esp
c0101cdd:	50                   	push   %eax
c0101cde:	68 cb 5f 10 c0       	push   $0xc0105fcb
c0101ce3:	e8 84 e5 ff ff       	call   c010026c <cprintf>
c0101ce8:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cf1:	83 ec 08             	sub    $0x8,%esp
c0101cf4:	50                   	push   %eax
c0101cf5:	68 da 5f 10 c0       	push   $0xc0105fda
c0101cfa:	e8 6d e5 ff ff       	call   c010026c <cprintf>
c0101cff:	83 c4 10             	add    $0x10,%esp
}
c0101d02:	90                   	nop
c0101d03:	c9                   	leave  
c0101d04:	c3                   	ret    

c0101d05 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d05:	55                   	push   %ebp
c0101d06:	89 e5                	mov    %esp,%ebp
c0101d08:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0e:	8b 40 30             	mov    0x30(%eax),%eax
c0101d11:	83 f8 2f             	cmp    $0x2f,%eax
c0101d14:	77 1d                	ja     c0101d33 <trap_dispatch+0x2e>
c0101d16:	83 f8 2e             	cmp    $0x2e,%eax
c0101d19:	0f 83 f4 00 00 00    	jae    c0101e13 <trap_dispatch+0x10e>
c0101d1f:	83 f8 21             	cmp    $0x21,%eax
c0101d22:	74 7e                	je     c0101da2 <trap_dispatch+0x9d>
c0101d24:	83 f8 24             	cmp    $0x24,%eax
c0101d27:	74 55                	je     c0101d7e <trap_dispatch+0x79>
c0101d29:	83 f8 20             	cmp    $0x20,%eax
c0101d2c:	74 16                	je     c0101d44 <trap_dispatch+0x3f>
c0101d2e:	e9 aa 00 00 00       	jmp    c0101ddd <trap_dispatch+0xd8>
c0101d33:	83 e8 78             	sub    $0x78,%eax
c0101d36:	83 f8 01             	cmp    $0x1,%eax
c0101d39:	0f 87 9e 00 00 00    	ja     c0101ddd <trap_dispatch+0xd8>
c0101d3f:	e9 82 00 00 00       	jmp    c0101dc6 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d44:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d49:	83 c0 01             	add    $0x1,%eax
c0101d4c:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101d51:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d57:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d5c:	89 c8                	mov    %ecx,%eax
c0101d5e:	f7 e2                	mul    %edx
c0101d60:	89 d0                	mov    %edx,%eax
c0101d62:	c1 e8 05             	shr    $0x5,%eax
c0101d65:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d68:	29 c1                	sub    %eax,%ecx
c0101d6a:	89 c8                	mov    %ecx,%eax
c0101d6c:	85 c0                	test   %eax,%eax
c0101d6e:	0f 85 a2 00 00 00    	jne    c0101e16 <trap_dispatch+0x111>
            print_ticks();
c0101d74:	e8 fa fa ff ff       	call   c0101873 <print_ticks>
        }
        break;
c0101d79:	e9 98 00 00 00       	jmp    c0101e16 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d7e:	e8 ad f8 ff ff       	call   c0101630 <cons_getc>
c0101d83:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d86:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d8a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d8e:	83 ec 04             	sub    $0x4,%esp
c0101d91:	52                   	push   %edx
c0101d92:	50                   	push   %eax
c0101d93:	68 e9 5f 10 c0       	push   $0xc0105fe9
c0101d98:	e8 cf e4 ff ff       	call   c010026c <cprintf>
c0101d9d:	83 c4 10             	add    $0x10,%esp
        break;
c0101da0:	eb 75                	jmp    c0101e17 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101da2:	e8 89 f8 ff ff       	call   c0101630 <cons_getc>
c0101da7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101daa:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101db2:	83 ec 04             	sub    $0x4,%esp
c0101db5:	52                   	push   %edx
c0101db6:	50                   	push   %eax
c0101db7:	68 fb 5f 10 c0       	push   $0xc0105ffb
c0101dbc:	e8 ab e4 ff ff       	call   c010026c <cprintf>
c0101dc1:	83 c4 10             	add    $0x10,%esp
        break;
c0101dc4:	eb 51                	jmp    c0101e17 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dc6:	83 ec 04             	sub    $0x4,%esp
c0101dc9:	68 0a 60 10 c0       	push   $0xc010600a
c0101dce:	68 af 00 00 00       	push   $0xaf
c0101dd3:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101dd8:	e8 f5 e5 ff ff       	call   c01003d2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101de4:	0f b7 c0             	movzwl %ax,%eax
c0101de7:	83 e0 03             	and    $0x3,%eax
c0101dea:	85 c0                	test   %eax,%eax
c0101dec:	75 29                	jne    c0101e17 <trap_dispatch+0x112>
            print_trapframe(tf);
c0101dee:	83 ec 0c             	sub    $0xc,%esp
c0101df1:	ff 75 08             	pushl  0x8(%ebp)
c0101df4:	e8 6f fc ff ff       	call   c0101a68 <print_trapframe>
c0101df9:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101dfc:	83 ec 04             	sub    $0x4,%esp
c0101dff:	68 1a 60 10 c0       	push   $0xc010601a
c0101e04:	68 b9 00 00 00       	push   $0xb9
c0101e09:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101e0e:	e8 bf e5 ff ff       	call   c01003d2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e13:	90                   	nop
c0101e14:	eb 01                	jmp    c0101e17 <trap_dispatch+0x112>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0101e16:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e17:	90                   	nop
c0101e18:	c9                   	leave  
c0101e19:	c3                   	ret    

c0101e1a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e1a:	55                   	push   %ebp
c0101e1b:	89 e5                	mov    %esp,%ebp
c0101e1d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e20:	83 ec 0c             	sub    $0xc,%esp
c0101e23:	ff 75 08             	pushl  0x8(%ebp)
c0101e26:	e8 da fe ff ff       	call   c0101d05 <trap_dispatch>
c0101e2b:	83 c4 10             	add    $0x10,%esp
}
c0101e2e:	90                   	nop
c0101e2f:	c9                   	leave  
c0101e30:	c3                   	ret    

c0101e31 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e31:	6a 00                	push   $0x0
  pushl $0
c0101e33:	6a 00                	push   $0x0
  jmp __alltraps
c0101e35:	e9 67 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e3a <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e3a:	6a 00                	push   $0x0
  pushl $1
c0101e3c:	6a 01                	push   $0x1
  jmp __alltraps
c0101e3e:	e9 5e 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e43 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e43:	6a 00                	push   $0x0
  pushl $2
c0101e45:	6a 02                	push   $0x2
  jmp __alltraps
c0101e47:	e9 55 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e4c <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e4c:	6a 00                	push   $0x0
  pushl $3
c0101e4e:	6a 03                	push   $0x3
  jmp __alltraps
c0101e50:	e9 4c 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e55 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e55:	6a 00                	push   $0x0
  pushl $4
c0101e57:	6a 04                	push   $0x4
  jmp __alltraps
c0101e59:	e9 43 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e5e <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e5e:	6a 00                	push   $0x0
  pushl $5
c0101e60:	6a 05                	push   $0x5
  jmp __alltraps
c0101e62:	e9 3a 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e67 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e67:	6a 00                	push   $0x0
  pushl $6
c0101e69:	6a 06                	push   $0x6
  jmp __alltraps
c0101e6b:	e9 31 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e70 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e70:	6a 00                	push   $0x0
  pushl $7
c0101e72:	6a 07                	push   $0x7
  jmp __alltraps
c0101e74:	e9 28 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e79 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e79:	6a 08                	push   $0x8
  jmp __alltraps
c0101e7b:	e9 21 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e80 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e80:	6a 09                	push   $0x9
  jmp __alltraps
c0101e82:	e9 1a 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e87 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e87:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e89:	e9 13 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e8e <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e8e:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e90:	e9 0c 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e95 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e95:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e97:	e9 05 0a 00 00       	jmp    c01028a1 <__alltraps>

c0101e9c <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e9c:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e9e:	e9 fe 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ea3 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ea3:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ea5:	e9 f7 09 00 00       	jmp    c01028a1 <__alltraps>

c0101eaa <vector15>:
.globl vector15
vector15:
  pushl $0
c0101eaa:	6a 00                	push   $0x0
  pushl $15
c0101eac:	6a 0f                	push   $0xf
  jmp __alltraps
c0101eae:	e9 ee 09 00 00       	jmp    c01028a1 <__alltraps>

c0101eb3 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101eb3:	6a 00                	push   $0x0
  pushl $16
c0101eb5:	6a 10                	push   $0x10
  jmp __alltraps
c0101eb7:	e9 e5 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ebc <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ebc:	6a 11                	push   $0x11
  jmp __alltraps
c0101ebe:	e9 de 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ec3 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $18
c0101ec5:	6a 12                	push   $0x12
  jmp __alltraps
c0101ec7:	e9 d5 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ecc <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ecc:	6a 00                	push   $0x0
  pushl $19
c0101ece:	6a 13                	push   $0x13
  jmp __alltraps
c0101ed0:	e9 cc 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ed5 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ed5:	6a 00                	push   $0x0
  pushl $20
c0101ed7:	6a 14                	push   $0x14
  jmp __alltraps
c0101ed9:	e9 c3 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ede <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ede:	6a 00                	push   $0x0
  pushl $21
c0101ee0:	6a 15                	push   $0x15
  jmp __alltraps
c0101ee2:	e9 ba 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ee7 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ee7:	6a 00                	push   $0x0
  pushl $22
c0101ee9:	6a 16                	push   $0x16
  jmp __alltraps
c0101eeb:	e9 b1 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ef0 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ef0:	6a 00                	push   $0x0
  pushl $23
c0101ef2:	6a 17                	push   $0x17
  jmp __alltraps
c0101ef4:	e9 a8 09 00 00       	jmp    c01028a1 <__alltraps>

c0101ef9 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ef9:	6a 00                	push   $0x0
  pushl $24
c0101efb:	6a 18                	push   $0x18
  jmp __alltraps
c0101efd:	e9 9f 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f02 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f02:	6a 00                	push   $0x0
  pushl $25
c0101f04:	6a 19                	push   $0x19
  jmp __alltraps
c0101f06:	e9 96 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f0b <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f0b:	6a 00                	push   $0x0
  pushl $26
c0101f0d:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f0f:	e9 8d 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f14 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f14:	6a 00                	push   $0x0
  pushl $27
c0101f16:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f18:	e9 84 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f1d <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $28
c0101f1f:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f21:	e9 7b 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f26 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $29
c0101f28:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f2a:	e9 72 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f2f <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f2f:	6a 00                	push   $0x0
  pushl $30
c0101f31:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f33:	e9 69 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f38 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $31
c0101f3a:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f3c:	e9 60 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f41 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $32
c0101f43:	6a 20                	push   $0x20
  jmp __alltraps
c0101f45:	e9 57 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f4a <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $33
c0101f4c:	6a 21                	push   $0x21
  jmp __alltraps
c0101f4e:	e9 4e 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f53 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $34
c0101f55:	6a 22                	push   $0x22
  jmp __alltraps
c0101f57:	e9 45 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f5c <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f5c:	6a 00                	push   $0x0
  pushl $35
c0101f5e:	6a 23                	push   $0x23
  jmp __alltraps
c0101f60:	e9 3c 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f65 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $36
c0101f67:	6a 24                	push   $0x24
  jmp __alltraps
c0101f69:	e9 33 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f6e <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $37
c0101f70:	6a 25                	push   $0x25
  jmp __alltraps
c0101f72:	e9 2a 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f77 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $38
c0101f79:	6a 26                	push   $0x26
  jmp __alltraps
c0101f7b:	e9 21 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f80 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f80:	6a 00                	push   $0x0
  pushl $39
c0101f82:	6a 27                	push   $0x27
  jmp __alltraps
c0101f84:	e9 18 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f89 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $40
c0101f8b:	6a 28                	push   $0x28
  jmp __alltraps
c0101f8d:	e9 0f 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f92 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $41
c0101f94:	6a 29                	push   $0x29
  jmp __alltraps
c0101f96:	e9 06 09 00 00       	jmp    c01028a1 <__alltraps>

c0101f9b <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f9b:	6a 00                	push   $0x0
  pushl $42
c0101f9d:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f9f:	e9 fd 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fa4 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $43
c0101fa6:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fa8:	e9 f4 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fad <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $44
c0101faf:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fb1:	e9 eb 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fb6 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $45
c0101fb8:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fba:	e9 e2 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fbf <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $46
c0101fc1:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fc3:	e9 d9 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fc8 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $47
c0101fca:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fcc:	e9 d0 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fd1 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $48
c0101fd3:	6a 30                	push   $0x30
  jmp __alltraps
c0101fd5:	e9 c7 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fda <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $49
c0101fdc:	6a 31                	push   $0x31
  jmp __alltraps
c0101fde:	e9 be 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fe3 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $50
c0101fe5:	6a 32                	push   $0x32
  jmp __alltraps
c0101fe7:	e9 b5 08 00 00       	jmp    c01028a1 <__alltraps>

c0101fec <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $51
c0101fee:	6a 33                	push   $0x33
  jmp __alltraps
c0101ff0:	e9 ac 08 00 00       	jmp    c01028a1 <__alltraps>

c0101ff5 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $52
c0101ff7:	6a 34                	push   $0x34
  jmp __alltraps
c0101ff9:	e9 a3 08 00 00       	jmp    c01028a1 <__alltraps>

c0101ffe <vector53>:
.globl vector53
vector53:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $53
c0102000:	6a 35                	push   $0x35
  jmp __alltraps
c0102002:	e9 9a 08 00 00       	jmp    c01028a1 <__alltraps>

c0102007 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $54
c0102009:	6a 36                	push   $0x36
  jmp __alltraps
c010200b:	e9 91 08 00 00       	jmp    c01028a1 <__alltraps>

c0102010 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $55
c0102012:	6a 37                	push   $0x37
  jmp __alltraps
c0102014:	e9 88 08 00 00       	jmp    c01028a1 <__alltraps>

c0102019 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $56
c010201b:	6a 38                	push   $0x38
  jmp __alltraps
c010201d:	e9 7f 08 00 00       	jmp    c01028a1 <__alltraps>

c0102022 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $57
c0102024:	6a 39                	push   $0x39
  jmp __alltraps
c0102026:	e9 76 08 00 00       	jmp    c01028a1 <__alltraps>

c010202b <vector58>:
.globl vector58
vector58:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $58
c010202d:	6a 3a                	push   $0x3a
  jmp __alltraps
c010202f:	e9 6d 08 00 00       	jmp    c01028a1 <__alltraps>

c0102034 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $59
c0102036:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102038:	e9 64 08 00 00       	jmp    c01028a1 <__alltraps>

c010203d <vector60>:
.globl vector60
vector60:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $60
c010203f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102041:	e9 5b 08 00 00       	jmp    c01028a1 <__alltraps>

c0102046 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $61
c0102048:	6a 3d                	push   $0x3d
  jmp __alltraps
c010204a:	e9 52 08 00 00       	jmp    c01028a1 <__alltraps>

c010204f <vector62>:
.globl vector62
vector62:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $62
c0102051:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102053:	e9 49 08 00 00       	jmp    c01028a1 <__alltraps>

c0102058 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $63
c010205a:	6a 3f                	push   $0x3f
  jmp __alltraps
c010205c:	e9 40 08 00 00       	jmp    c01028a1 <__alltraps>

c0102061 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $64
c0102063:	6a 40                	push   $0x40
  jmp __alltraps
c0102065:	e9 37 08 00 00       	jmp    c01028a1 <__alltraps>

c010206a <vector65>:
.globl vector65
vector65:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $65
c010206c:	6a 41                	push   $0x41
  jmp __alltraps
c010206e:	e9 2e 08 00 00       	jmp    c01028a1 <__alltraps>

c0102073 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $66
c0102075:	6a 42                	push   $0x42
  jmp __alltraps
c0102077:	e9 25 08 00 00       	jmp    c01028a1 <__alltraps>

c010207c <vector67>:
.globl vector67
vector67:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $67
c010207e:	6a 43                	push   $0x43
  jmp __alltraps
c0102080:	e9 1c 08 00 00       	jmp    c01028a1 <__alltraps>

c0102085 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $68
c0102087:	6a 44                	push   $0x44
  jmp __alltraps
c0102089:	e9 13 08 00 00       	jmp    c01028a1 <__alltraps>

c010208e <vector69>:
.globl vector69
vector69:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $69
c0102090:	6a 45                	push   $0x45
  jmp __alltraps
c0102092:	e9 0a 08 00 00       	jmp    c01028a1 <__alltraps>

c0102097 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $70
c0102099:	6a 46                	push   $0x46
  jmp __alltraps
c010209b:	e9 01 08 00 00       	jmp    c01028a1 <__alltraps>

c01020a0 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $71
c01020a2:	6a 47                	push   $0x47
  jmp __alltraps
c01020a4:	e9 f8 07 00 00       	jmp    c01028a1 <__alltraps>

c01020a9 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $72
c01020ab:	6a 48                	push   $0x48
  jmp __alltraps
c01020ad:	e9 ef 07 00 00       	jmp    c01028a1 <__alltraps>

c01020b2 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $73
c01020b4:	6a 49                	push   $0x49
  jmp __alltraps
c01020b6:	e9 e6 07 00 00       	jmp    c01028a1 <__alltraps>

c01020bb <vector74>:
.globl vector74
vector74:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $74
c01020bd:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020bf:	e9 dd 07 00 00       	jmp    c01028a1 <__alltraps>

c01020c4 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $75
c01020c6:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020c8:	e9 d4 07 00 00       	jmp    c01028a1 <__alltraps>

c01020cd <vector76>:
.globl vector76
vector76:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $76
c01020cf:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020d1:	e9 cb 07 00 00       	jmp    c01028a1 <__alltraps>

c01020d6 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $77
c01020d8:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020da:	e9 c2 07 00 00       	jmp    c01028a1 <__alltraps>

c01020df <vector78>:
.globl vector78
vector78:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $78
c01020e1:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020e3:	e9 b9 07 00 00       	jmp    c01028a1 <__alltraps>

c01020e8 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $79
c01020ea:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020ec:	e9 b0 07 00 00       	jmp    c01028a1 <__alltraps>

c01020f1 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $80
c01020f3:	6a 50                	push   $0x50
  jmp __alltraps
c01020f5:	e9 a7 07 00 00       	jmp    c01028a1 <__alltraps>

c01020fa <vector81>:
.globl vector81
vector81:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $81
c01020fc:	6a 51                	push   $0x51
  jmp __alltraps
c01020fe:	e9 9e 07 00 00       	jmp    c01028a1 <__alltraps>

c0102103 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $82
c0102105:	6a 52                	push   $0x52
  jmp __alltraps
c0102107:	e9 95 07 00 00       	jmp    c01028a1 <__alltraps>

c010210c <vector83>:
.globl vector83
vector83:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $83
c010210e:	6a 53                	push   $0x53
  jmp __alltraps
c0102110:	e9 8c 07 00 00       	jmp    c01028a1 <__alltraps>

c0102115 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $84
c0102117:	6a 54                	push   $0x54
  jmp __alltraps
c0102119:	e9 83 07 00 00       	jmp    c01028a1 <__alltraps>

c010211e <vector85>:
.globl vector85
vector85:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $85
c0102120:	6a 55                	push   $0x55
  jmp __alltraps
c0102122:	e9 7a 07 00 00       	jmp    c01028a1 <__alltraps>

c0102127 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $86
c0102129:	6a 56                	push   $0x56
  jmp __alltraps
c010212b:	e9 71 07 00 00       	jmp    c01028a1 <__alltraps>

c0102130 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $87
c0102132:	6a 57                	push   $0x57
  jmp __alltraps
c0102134:	e9 68 07 00 00       	jmp    c01028a1 <__alltraps>

c0102139 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $88
c010213b:	6a 58                	push   $0x58
  jmp __alltraps
c010213d:	e9 5f 07 00 00       	jmp    c01028a1 <__alltraps>

c0102142 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $89
c0102144:	6a 59                	push   $0x59
  jmp __alltraps
c0102146:	e9 56 07 00 00       	jmp    c01028a1 <__alltraps>

c010214b <vector90>:
.globl vector90
vector90:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $90
c010214d:	6a 5a                	push   $0x5a
  jmp __alltraps
c010214f:	e9 4d 07 00 00       	jmp    c01028a1 <__alltraps>

c0102154 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $91
c0102156:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102158:	e9 44 07 00 00       	jmp    c01028a1 <__alltraps>

c010215d <vector92>:
.globl vector92
vector92:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $92
c010215f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102161:	e9 3b 07 00 00       	jmp    c01028a1 <__alltraps>

c0102166 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $93
c0102168:	6a 5d                	push   $0x5d
  jmp __alltraps
c010216a:	e9 32 07 00 00       	jmp    c01028a1 <__alltraps>

c010216f <vector94>:
.globl vector94
vector94:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $94
c0102171:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102173:	e9 29 07 00 00       	jmp    c01028a1 <__alltraps>

c0102178 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $95
c010217a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010217c:	e9 20 07 00 00       	jmp    c01028a1 <__alltraps>

c0102181 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $96
c0102183:	6a 60                	push   $0x60
  jmp __alltraps
c0102185:	e9 17 07 00 00       	jmp    c01028a1 <__alltraps>

c010218a <vector97>:
.globl vector97
vector97:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $97
c010218c:	6a 61                	push   $0x61
  jmp __alltraps
c010218e:	e9 0e 07 00 00       	jmp    c01028a1 <__alltraps>

c0102193 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $98
c0102195:	6a 62                	push   $0x62
  jmp __alltraps
c0102197:	e9 05 07 00 00       	jmp    c01028a1 <__alltraps>

c010219c <vector99>:
.globl vector99
vector99:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $99
c010219e:	6a 63                	push   $0x63
  jmp __alltraps
c01021a0:	e9 fc 06 00 00       	jmp    c01028a1 <__alltraps>

c01021a5 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $100
c01021a7:	6a 64                	push   $0x64
  jmp __alltraps
c01021a9:	e9 f3 06 00 00       	jmp    c01028a1 <__alltraps>

c01021ae <vector101>:
.globl vector101
vector101:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $101
c01021b0:	6a 65                	push   $0x65
  jmp __alltraps
c01021b2:	e9 ea 06 00 00       	jmp    c01028a1 <__alltraps>

c01021b7 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $102
c01021b9:	6a 66                	push   $0x66
  jmp __alltraps
c01021bb:	e9 e1 06 00 00       	jmp    c01028a1 <__alltraps>

c01021c0 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $103
c01021c2:	6a 67                	push   $0x67
  jmp __alltraps
c01021c4:	e9 d8 06 00 00       	jmp    c01028a1 <__alltraps>

c01021c9 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $104
c01021cb:	6a 68                	push   $0x68
  jmp __alltraps
c01021cd:	e9 cf 06 00 00       	jmp    c01028a1 <__alltraps>

c01021d2 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $105
c01021d4:	6a 69                	push   $0x69
  jmp __alltraps
c01021d6:	e9 c6 06 00 00       	jmp    c01028a1 <__alltraps>

c01021db <vector106>:
.globl vector106
vector106:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $106
c01021dd:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021df:	e9 bd 06 00 00       	jmp    c01028a1 <__alltraps>

c01021e4 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $107
c01021e6:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021e8:	e9 b4 06 00 00       	jmp    c01028a1 <__alltraps>

c01021ed <vector108>:
.globl vector108
vector108:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $108
c01021ef:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021f1:	e9 ab 06 00 00       	jmp    c01028a1 <__alltraps>

c01021f6 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $109
c01021f8:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021fa:	e9 a2 06 00 00       	jmp    c01028a1 <__alltraps>

c01021ff <vector110>:
.globl vector110
vector110:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $110
c0102201:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102203:	e9 99 06 00 00       	jmp    c01028a1 <__alltraps>

c0102208 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $111
c010220a:	6a 6f                	push   $0x6f
  jmp __alltraps
c010220c:	e9 90 06 00 00       	jmp    c01028a1 <__alltraps>

c0102211 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $112
c0102213:	6a 70                	push   $0x70
  jmp __alltraps
c0102215:	e9 87 06 00 00       	jmp    c01028a1 <__alltraps>

c010221a <vector113>:
.globl vector113
vector113:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $113
c010221c:	6a 71                	push   $0x71
  jmp __alltraps
c010221e:	e9 7e 06 00 00       	jmp    c01028a1 <__alltraps>

c0102223 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $114
c0102225:	6a 72                	push   $0x72
  jmp __alltraps
c0102227:	e9 75 06 00 00       	jmp    c01028a1 <__alltraps>

c010222c <vector115>:
.globl vector115
vector115:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $115
c010222e:	6a 73                	push   $0x73
  jmp __alltraps
c0102230:	e9 6c 06 00 00       	jmp    c01028a1 <__alltraps>

c0102235 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $116
c0102237:	6a 74                	push   $0x74
  jmp __alltraps
c0102239:	e9 63 06 00 00       	jmp    c01028a1 <__alltraps>

c010223e <vector117>:
.globl vector117
vector117:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $117
c0102240:	6a 75                	push   $0x75
  jmp __alltraps
c0102242:	e9 5a 06 00 00       	jmp    c01028a1 <__alltraps>

c0102247 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $118
c0102249:	6a 76                	push   $0x76
  jmp __alltraps
c010224b:	e9 51 06 00 00       	jmp    c01028a1 <__alltraps>

c0102250 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $119
c0102252:	6a 77                	push   $0x77
  jmp __alltraps
c0102254:	e9 48 06 00 00       	jmp    c01028a1 <__alltraps>

c0102259 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $120
c010225b:	6a 78                	push   $0x78
  jmp __alltraps
c010225d:	e9 3f 06 00 00       	jmp    c01028a1 <__alltraps>

c0102262 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $121
c0102264:	6a 79                	push   $0x79
  jmp __alltraps
c0102266:	e9 36 06 00 00       	jmp    c01028a1 <__alltraps>

c010226b <vector122>:
.globl vector122
vector122:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $122
c010226d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010226f:	e9 2d 06 00 00       	jmp    c01028a1 <__alltraps>

c0102274 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $123
c0102276:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102278:	e9 24 06 00 00       	jmp    c01028a1 <__alltraps>

c010227d <vector124>:
.globl vector124
vector124:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $124
c010227f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102281:	e9 1b 06 00 00       	jmp    c01028a1 <__alltraps>

c0102286 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $125
c0102288:	6a 7d                	push   $0x7d
  jmp __alltraps
c010228a:	e9 12 06 00 00       	jmp    c01028a1 <__alltraps>

c010228f <vector126>:
.globl vector126
vector126:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $126
c0102291:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102293:	e9 09 06 00 00       	jmp    c01028a1 <__alltraps>

c0102298 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $127
c010229a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010229c:	e9 00 06 00 00       	jmp    c01028a1 <__alltraps>

c01022a1 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $128
c01022a3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022a8:	e9 f4 05 00 00       	jmp    c01028a1 <__alltraps>

c01022ad <vector129>:
.globl vector129
vector129:
  pushl $0
c01022ad:	6a 00                	push   $0x0
  pushl $129
c01022af:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022b4:	e9 e8 05 00 00       	jmp    c01028a1 <__alltraps>

c01022b9 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $130
c01022bb:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022c0:	e9 dc 05 00 00       	jmp    c01028a1 <__alltraps>

c01022c5 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $131
c01022c7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022cc:	e9 d0 05 00 00       	jmp    c01028a1 <__alltraps>

c01022d1 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $132
c01022d3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022d8:	e9 c4 05 00 00       	jmp    c01028a1 <__alltraps>

c01022dd <vector133>:
.globl vector133
vector133:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $133
c01022df:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022e4:	e9 b8 05 00 00       	jmp    c01028a1 <__alltraps>

c01022e9 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $134
c01022eb:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022f0:	e9 ac 05 00 00       	jmp    c01028a1 <__alltraps>

c01022f5 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $135
c01022f7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022fc:	e9 a0 05 00 00       	jmp    c01028a1 <__alltraps>

c0102301 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $136
c0102303:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102308:	e9 94 05 00 00       	jmp    c01028a1 <__alltraps>

c010230d <vector137>:
.globl vector137
vector137:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $137
c010230f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102314:	e9 88 05 00 00       	jmp    c01028a1 <__alltraps>

c0102319 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $138
c010231b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102320:	e9 7c 05 00 00       	jmp    c01028a1 <__alltraps>

c0102325 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $139
c0102327:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010232c:	e9 70 05 00 00       	jmp    c01028a1 <__alltraps>

c0102331 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $140
c0102333:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102338:	e9 64 05 00 00       	jmp    c01028a1 <__alltraps>

c010233d <vector141>:
.globl vector141
vector141:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $141
c010233f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102344:	e9 58 05 00 00       	jmp    c01028a1 <__alltraps>

c0102349 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $142
c010234b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102350:	e9 4c 05 00 00       	jmp    c01028a1 <__alltraps>

c0102355 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $143
c0102357:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010235c:	e9 40 05 00 00       	jmp    c01028a1 <__alltraps>

c0102361 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $144
c0102363:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102368:	e9 34 05 00 00       	jmp    c01028a1 <__alltraps>

c010236d <vector145>:
.globl vector145
vector145:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $145
c010236f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102374:	e9 28 05 00 00       	jmp    c01028a1 <__alltraps>

c0102379 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $146
c010237b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102380:	e9 1c 05 00 00       	jmp    c01028a1 <__alltraps>

c0102385 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $147
c0102387:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010238c:	e9 10 05 00 00       	jmp    c01028a1 <__alltraps>

c0102391 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $148
c0102393:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102398:	e9 04 05 00 00       	jmp    c01028a1 <__alltraps>

c010239d <vector149>:
.globl vector149
vector149:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $149
c010239f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023a4:	e9 f8 04 00 00       	jmp    c01028a1 <__alltraps>

c01023a9 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $150
c01023ab:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023b0:	e9 ec 04 00 00       	jmp    c01028a1 <__alltraps>

c01023b5 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $151
c01023b7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023bc:	e9 e0 04 00 00       	jmp    c01028a1 <__alltraps>

c01023c1 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $152
c01023c3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023c8:	e9 d4 04 00 00       	jmp    c01028a1 <__alltraps>

c01023cd <vector153>:
.globl vector153
vector153:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $153
c01023cf:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023d4:	e9 c8 04 00 00       	jmp    c01028a1 <__alltraps>

c01023d9 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $154
c01023db:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023e0:	e9 bc 04 00 00       	jmp    c01028a1 <__alltraps>

c01023e5 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $155
c01023e7:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023ec:	e9 b0 04 00 00       	jmp    c01028a1 <__alltraps>

c01023f1 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $156
c01023f3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023f8:	e9 a4 04 00 00       	jmp    c01028a1 <__alltraps>

c01023fd <vector157>:
.globl vector157
vector157:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $157
c01023ff:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102404:	e9 98 04 00 00       	jmp    c01028a1 <__alltraps>

c0102409 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $158
c010240b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102410:	e9 8c 04 00 00       	jmp    c01028a1 <__alltraps>

c0102415 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $159
c0102417:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010241c:	e9 80 04 00 00       	jmp    c01028a1 <__alltraps>

c0102421 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102421:	6a 00                	push   $0x0
  pushl $160
c0102423:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102428:	e9 74 04 00 00       	jmp    c01028a1 <__alltraps>

c010242d <vector161>:
.globl vector161
vector161:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $161
c010242f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102434:	e9 68 04 00 00       	jmp    c01028a1 <__alltraps>

c0102439 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $162
c010243b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102440:	e9 5c 04 00 00       	jmp    c01028a1 <__alltraps>

c0102445 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102445:	6a 00                	push   $0x0
  pushl $163
c0102447:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010244c:	e9 50 04 00 00       	jmp    c01028a1 <__alltraps>

c0102451 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $164
c0102453:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102458:	e9 44 04 00 00       	jmp    c01028a1 <__alltraps>

c010245d <vector165>:
.globl vector165
vector165:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $165
c010245f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102464:	e9 38 04 00 00       	jmp    c01028a1 <__alltraps>

c0102469 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102469:	6a 00                	push   $0x0
  pushl $166
c010246b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102470:	e9 2c 04 00 00       	jmp    c01028a1 <__alltraps>

c0102475 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $167
c0102477:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010247c:	e9 20 04 00 00       	jmp    c01028a1 <__alltraps>

c0102481 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $168
c0102483:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102488:	e9 14 04 00 00       	jmp    c01028a1 <__alltraps>

c010248d <vector169>:
.globl vector169
vector169:
  pushl $0
c010248d:	6a 00                	push   $0x0
  pushl $169
c010248f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102494:	e9 08 04 00 00       	jmp    c01028a1 <__alltraps>

c0102499 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $170
c010249b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024a0:	e9 fc 03 00 00       	jmp    c01028a1 <__alltraps>

c01024a5 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $171
c01024a7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024ac:	e9 f0 03 00 00       	jmp    c01028a1 <__alltraps>

c01024b1 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024b1:	6a 00                	push   $0x0
  pushl $172
c01024b3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024b8:	e9 e4 03 00 00       	jmp    c01028a1 <__alltraps>

c01024bd <vector173>:
.globl vector173
vector173:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $173
c01024bf:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024c4:	e9 d8 03 00 00       	jmp    c01028a1 <__alltraps>

c01024c9 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $174
c01024cb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024d0:	e9 cc 03 00 00       	jmp    c01028a1 <__alltraps>

c01024d5 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024d5:	6a 00                	push   $0x0
  pushl $175
c01024d7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024dc:	e9 c0 03 00 00       	jmp    c01028a1 <__alltraps>

c01024e1 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $176
c01024e3:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024e8:	e9 b4 03 00 00       	jmp    c01028a1 <__alltraps>

c01024ed <vector177>:
.globl vector177
vector177:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $177
c01024ef:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024f4:	e9 a8 03 00 00       	jmp    c01028a1 <__alltraps>

c01024f9 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024f9:	6a 00                	push   $0x0
  pushl $178
c01024fb:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102500:	e9 9c 03 00 00       	jmp    c01028a1 <__alltraps>

c0102505 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $179
c0102507:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010250c:	e9 90 03 00 00       	jmp    c01028a1 <__alltraps>

c0102511 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $180
c0102513:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102518:	e9 84 03 00 00       	jmp    c01028a1 <__alltraps>

c010251d <vector181>:
.globl vector181
vector181:
  pushl $0
c010251d:	6a 00                	push   $0x0
  pushl $181
c010251f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102524:	e9 78 03 00 00       	jmp    c01028a1 <__alltraps>

c0102529 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $182
c010252b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102530:	e9 6c 03 00 00       	jmp    c01028a1 <__alltraps>

c0102535 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $183
c0102537:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010253c:	e9 60 03 00 00       	jmp    c01028a1 <__alltraps>

c0102541 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102541:	6a 00                	push   $0x0
  pushl $184
c0102543:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102548:	e9 54 03 00 00       	jmp    c01028a1 <__alltraps>

c010254d <vector185>:
.globl vector185
vector185:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $185
c010254f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102554:	e9 48 03 00 00       	jmp    c01028a1 <__alltraps>

c0102559 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $186
c010255b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102560:	e9 3c 03 00 00       	jmp    c01028a1 <__alltraps>

c0102565 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102565:	6a 00                	push   $0x0
  pushl $187
c0102567:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010256c:	e9 30 03 00 00       	jmp    c01028a1 <__alltraps>

c0102571 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $188
c0102573:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102578:	e9 24 03 00 00       	jmp    c01028a1 <__alltraps>

c010257d <vector189>:
.globl vector189
vector189:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $189
c010257f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102584:	e9 18 03 00 00       	jmp    c01028a1 <__alltraps>

c0102589 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102589:	6a 00                	push   $0x0
  pushl $190
c010258b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102590:	e9 0c 03 00 00       	jmp    c01028a1 <__alltraps>

c0102595 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $191
c0102597:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010259c:	e9 00 03 00 00       	jmp    c01028a1 <__alltraps>

c01025a1 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $192
c01025a3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025a8:	e9 f4 02 00 00       	jmp    c01028a1 <__alltraps>

c01025ad <vector193>:
.globl vector193
vector193:
  pushl $0
c01025ad:	6a 00                	push   $0x0
  pushl $193
c01025af:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025b4:	e9 e8 02 00 00       	jmp    c01028a1 <__alltraps>

c01025b9 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $194
c01025bb:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025c0:	e9 dc 02 00 00       	jmp    c01028a1 <__alltraps>

c01025c5 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $195
c01025c7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025cc:	e9 d0 02 00 00       	jmp    c01028a1 <__alltraps>

c01025d1 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025d1:	6a 00                	push   $0x0
  pushl $196
c01025d3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025d8:	e9 c4 02 00 00       	jmp    c01028a1 <__alltraps>

c01025dd <vector197>:
.globl vector197
vector197:
  pushl $0
c01025dd:	6a 00                	push   $0x0
  pushl $197
c01025df:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025e4:	e9 b8 02 00 00       	jmp    c01028a1 <__alltraps>

c01025e9 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $198
c01025eb:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025f0:	e9 ac 02 00 00       	jmp    c01028a1 <__alltraps>

c01025f5 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025f5:	6a 00                	push   $0x0
  pushl $199
c01025f7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025fc:	e9 a0 02 00 00       	jmp    c01028a1 <__alltraps>

c0102601 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102601:	6a 00                	push   $0x0
  pushl $200
c0102603:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102608:	e9 94 02 00 00       	jmp    c01028a1 <__alltraps>

c010260d <vector201>:
.globl vector201
vector201:
  pushl $0
c010260d:	6a 00                	push   $0x0
  pushl $201
c010260f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102614:	e9 88 02 00 00       	jmp    c01028a1 <__alltraps>

c0102619 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102619:	6a 00                	push   $0x0
  pushl $202
c010261b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102620:	e9 7c 02 00 00       	jmp    c01028a1 <__alltraps>

c0102625 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102625:	6a 00                	push   $0x0
  pushl $203
c0102627:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010262c:	e9 70 02 00 00       	jmp    c01028a1 <__alltraps>

c0102631 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102631:	6a 00                	push   $0x0
  pushl $204
c0102633:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102638:	e9 64 02 00 00       	jmp    c01028a1 <__alltraps>

c010263d <vector205>:
.globl vector205
vector205:
  pushl $0
c010263d:	6a 00                	push   $0x0
  pushl $205
c010263f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102644:	e9 58 02 00 00       	jmp    c01028a1 <__alltraps>

c0102649 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102649:	6a 00                	push   $0x0
  pushl $206
c010264b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102650:	e9 4c 02 00 00       	jmp    c01028a1 <__alltraps>

c0102655 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102655:	6a 00                	push   $0x0
  pushl $207
c0102657:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010265c:	e9 40 02 00 00       	jmp    c01028a1 <__alltraps>

c0102661 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102661:	6a 00                	push   $0x0
  pushl $208
c0102663:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102668:	e9 34 02 00 00       	jmp    c01028a1 <__alltraps>

c010266d <vector209>:
.globl vector209
vector209:
  pushl $0
c010266d:	6a 00                	push   $0x0
  pushl $209
c010266f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102674:	e9 28 02 00 00       	jmp    c01028a1 <__alltraps>

c0102679 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102679:	6a 00                	push   $0x0
  pushl $210
c010267b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102680:	e9 1c 02 00 00       	jmp    c01028a1 <__alltraps>

c0102685 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102685:	6a 00                	push   $0x0
  pushl $211
c0102687:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010268c:	e9 10 02 00 00       	jmp    c01028a1 <__alltraps>

c0102691 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102691:	6a 00                	push   $0x0
  pushl $212
c0102693:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102698:	e9 04 02 00 00       	jmp    c01028a1 <__alltraps>

c010269d <vector213>:
.globl vector213
vector213:
  pushl $0
c010269d:	6a 00                	push   $0x0
  pushl $213
c010269f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026a4:	e9 f8 01 00 00       	jmp    c01028a1 <__alltraps>

c01026a9 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026a9:	6a 00                	push   $0x0
  pushl $214
c01026ab:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026b0:	e9 ec 01 00 00       	jmp    c01028a1 <__alltraps>

c01026b5 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026b5:	6a 00                	push   $0x0
  pushl $215
c01026b7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026bc:	e9 e0 01 00 00       	jmp    c01028a1 <__alltraps>

c01026c1 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026c1:	6a 00                	push   $0x0
  pushl $216
c01026c3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026c8:	e9 d4 01 00 00       	jmp    c01028a1 <__alltraps>

c01026cd <vector217>:
.globl vector217
vector217:
  pushl $0
c01026cd:	6a 00                	push   $0x0
  pushl $217
c01026cf:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026d4:	e9 c8 01 00 00       	jmp    c01028a1 <__alltraps>

c01026d9 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026d9:	6a 00                	push   $0x0
  pushl $218
c01026db:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026e0:	e9 bc 01 00 00       	jmp    c01028a1 <__alltraps>

c01026e5 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026e5:	6a 00                	push   $0x0
  pushl $219
c01026e7:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026ec:	e9 b0 01 00 00       	jmp    c01028a1 <__alltraps>

c01026f1 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026f1:	6a 00                	push   $0x0
  pushl $220
c01026f3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026f8:	e9 a4 01 00 00       	jmp    c01028a1 <__alltraps>

c01026fd <vector221>:
.globl vector221
vector221:
  pushl $0
c01026fd:	6a 00                	push   $0x0
  pushl $221
c01026ff:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102704:	e9 98 01 00 00       	jmp    c01028a1 <__alltraps>

c0102709 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102709:	6a 00                	push   $0x0
  pushl $222
c010270b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102710:	e9 8c 01 00 00       	jmp    c01028a1 <__alltraps>

c0102715 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102715:	6a 00                	push   $0x0
  pushl $223
c0102717:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010271c:	e9 80 01 00 00       	jmp    c01028a1 <__alltraps>

c0102721 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102721:	6a 00                	push   $0x0
  pushl $224
c0102723:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102728:	e9 74 01 00 00       	jmp    c01028a1 <__alltraps>

c010272d <vector225>:
.globl vector225
vector225:
  pushl $0
c010272d:	6a 00                	push   $0x0
  pushl $225
c010272f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102734:	e9 68 01 00 00       	jmp    c01028a1 <__alltraps>

c0102739 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102739:	6a 00                	push   $0x0
  pushl $226
c010273b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102740:	e9 5c 01 00 00       	jmp    c01028a1 <__alltraps>

c0102745 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102745:	6a 00                	push   $0x0
  pushl $227
c0102747:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010274c:	e9 50 01 00 00       	jmp    c01028a1 <__alltraps>

c0102751 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $228
c0102753:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102758:	e9 44 01 00 00       	jmp    c01028a1 <__alltraps>

c010275d <vector229>:
.globl vector229
vector229:
  pushl $0
c010275d:	6a 00                	push   $0x0
  pushl $229
c010275f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102764:	e9 38 01 00 00       	jmp    c01028a1 <__alltraps>

c0102769 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102769:	6a 00                	push   $0x0
  pushl $230
c010276b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102770:	e9 2c 01 00 00       	jmp    c01028a1 <__alltraps>

c0102775 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $231
c0102777:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010277c:	e9 20 01 00 00       	jmp    c01028a1 <__alltraps>

c0102781 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102781:	6a 00                	push   $0x0
  pushl $232
c0102783:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102788:	e9 14 01 00 00       	jmp    c01028a1 <__alltraps>

c010278d <vector233>:
.globl vector233
vector233:
  pushl $0
c010278d:	6a 00                	push   $0x0
  pushl $233
c010278f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102794:	e9 08 01 00 00       	jmp    c01028a1 <__alltraps>

c0102799 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102799:	6a 00                	push   $0x0
  pushl $234
c010279b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027a0:	e9 fc 00 00 00       	jmp    c01028a1 <__alltraps>

c01027a5 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027a5:	6a 00                	push   $0x0
  pushl $235
c01027a7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027ac:	e9 f0 00 00 00       	jmp    c01028a1 <__alltraps>

c01027b1 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027b1:	6a 00                	push   $0x0
  pushl $236
c01027b3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027b8:	e9 e4 00 00 00       	jmp    c01028a1 <__alltraps>

c01027bd <vector237>:
.globl vector237
vector237:
  pushl $0
c01027bd:	6a 00                	push   $0x0
  pushl $237
c01027bf:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027c4:	e9 d8 00 00 00       	jmp    c01028a1 <__alltraps>

c01027c9 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027c9:	6a 00                	push   $0x0
  pushl $238
c01027cb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027d0:	e9 cc 00 00 00       	jmp    c01028a1 <__alltraps>

c01027d5 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027d5:	6a 00                	push   $0x0
  pushl $239
c01027d7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027dc:	e9 c0 00 00 00       	jmp    c01028a1 <__alltraps>

c01027e1 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027e1:	6a 00                	push   $0x0
  pushl $240
c01027e3:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027e8:	e9 b4 00 00 00       	jmp    c01028a1 <__alltraps>

c01027ed <vector241>:
.globl vector241
vector241:
  pushl $0
c01027ed:	6a 00                	push   $0x0
  pushl $241
c01027ef:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027f4:	e9 a8 00 00 00       	jmp    c01028a1 <__alltraps>

c01027f9 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $242
c01027fb:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102800:	e9 9c 00 00 00       	jmp    c01028a1 <__alltraps>

c0102805 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102805:	6a 00                	push   $0x0
  pushl $243
c0102807:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010280c:	e9 90 00 00 00       	jmp    c01028a1 <__alltraps>

c0102811 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102811:	6a 00                	push   $0x0
  pushl $244
c0102813:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102818:	e9 84 00 00 00       	jmp    c01028a1 <__alltraps>

c010281d <vector245>:
.globl vector245
vector245:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $245
c010281f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102824:	e9 78 00 00 00       	jmp    c01028a1 <__alltraps>

c0102829 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102829:	6a 00                	push   $0x0
  pushl $246
c010282b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102830:	e9 6c 00 00 00       	jmp    c01028a1 <__alltraps>

c0102835 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102835:	6a 00                	push   $0x0
  pushl $247
c0102837:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010283c:	e9 60 00 00 00       	jmp    c01028a1 <__alltraps>

c0102841 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $248
c0102843:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102848:	e9 54 00 00 00       	jmp    c01028a1 <__alltraps>

c010284d <vector249>:
.globl vector249
vector249:
  pushl $0
c010284d:	6a 00                	push   $0x0
  pushl $249
c010284f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102854:	e9 48 00 00 00       	jmp    c01028a1 <__alltraps>

c0102859 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102859:	6a 00                	push   $0x0
  pushl $250
c010285b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102860:	e9 3c 00 00 00       	jmp    c01028a1 <__alltraps>

c0102865 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $251
c0102867:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010286c:	e9 30 00 00 00       	jmp    c01028a1 <__alltraps>

c0102871 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102871:	6a 00                	push   $0x0
  pushl $252
c0102873:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102878:	e9 24 00 00 00       	jmp    c01028a1 <__alltraps>

c010287d <vector253>:
.globl vector253
vector253:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $253
c010287f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102884:	e9 18 00 00 00       	jmp    c01028a1 <__alltraps>

c0102889 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $254
c010288b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102890:	e9 0c 00 00 00       	jmp    c01028a1 <__alltraps>

c0102895 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102895:	6a 00                	push   $0x0
  pushl $255
c0102897:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010289c:	e9 00 00 00 00       	jmp    c01028a1 <__alltraps>

c01028a1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01028a1:	1e                   	push   %ds
    pushl %es
c01028a2:	06                   	push   %es
    pushl %fs
c01028a3:	0f a0                	push   %fs
    pushl %gs
c01028a5:	0f a8                	push   %gs
    pushal
c01028a7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01028a8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01028ad:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01028af:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01028b1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01028b2:	e8 63 f5 ff ff       	call   c0101e1a <trap>

    # pop the pushed stack pointer
    popl %esp
c01028b7:	5c                   	pop    %esp

c01028b8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01028b8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01028b9:	0f a9                	pop    %gs
    popl %fs
c01028bb:	0f a1                	pop    %fs
    popl %es
c01028bd:	07                   	pop    %es
    popl %ds
c01028be:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01028bf:	83 c4 08             	add    $0x8,%esp
    iret
c01028c2:	cf                   	iret   

c01028c3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028c3:	55                   	push   %ebp
c01028c4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c9:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01028cf:	29 d0                	sub    %edx,%eax
c01028d1:	c1 f8 02             	sar    $0x2,%eax
c01028d4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028da:	5d                   	pop    %ebp
c01028db:	c3                   	ret    

c01028dc <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028dc:	55                   	push   %ebp
c01028dd:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01028df:	ff 75 08             	pushl  0x8(%ebp)
c01028e2:	e8 dc ff ff ff       	call   c01028c3 <page2ppn>
c01028e7:	83 c4 04             	add    $0x4,%esp
c01028ea:	c1 e0 0c             	shl    $0xc,%eax
}
c01028ed:	c9                   	leave  
c01028ee:	c3                   	ret    

c01028ef <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01028ef:	55                   	push   %ebp
c01028f0:	89 e5                	mov    %esp,%ebp
c01028f2:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01028f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f8:	c1 e8 0c             	shr    $0xc,%eax
c01028fb:	89 c2                	mov    %eax,%edx
c01028fd:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102902:	39 c2                	cmp    %eax,%edx
c0102904:	72 14                	jb     c010291a <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c0102906:	83 ec 04             	sub    $0x4,%esp
c0102909:	68 d0 61 10 c0       	push   $0xc01061d0
c010290e:	6a 5a                	push   $0x5a
c0102910:	68 ef 61 10 c0       	push   $0xc01061ef
c0102915:	e8 b8 da ff ff       	call   c01003d2 <__panic>
    }
    return &pages[PPN(pa)];
c010291a:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102920:	8b 45 08             	mov    0x8(%ebp),%eax
c0102923:	c1 e8 0c             	shr    $0xc,%eax
c0102926:	89 c2                	mov    %eax,%edx
c0102928:	89 d0                	mov    %edx,%eax
c010292a:	c1 e0 02             	shl    $0x2,%eax
c010292d:	01 d0                	add    %edx,%eax
c010292f:	c1 e0 02             	shl    $0x2,%eax
c0102932:	01 c8                	add    %ecx,%eax
}
c0102934:	c9                   	leave  
c0102935:	c3                   	ret    

c0102936 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102936:	55                   	push   %ebp
c0102937:	89 e5                	mov    %esp,%ebp
c0102939:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c010293c:	ff 75 08             	pushl  0x8(%ebp)
c010293f:	e8 98 ff ff ff       	call   c01028dc <page2pa>
c0102944:	83 c4 04             	add    $0x4,%esp
c0102947:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294d:	c1 e8 0c             	shr    $0xc,%eax
c0102950:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102953:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102958:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010295b:	72 14                	jb     c0102971 <page2kva+0x3b>
c010295d:	ff 75 f4             	pushl  -0xc(%ebp)
c0102960:	68 00 62 10 c0       	push   $0xc0106200
c0102965:	6a 61                	push   $0x61
c0102967:	68 ef 61 10 c0       	push   $0xc01061ef
c010296c:	e8 61 da ff ff       	call   c01003d2 <__panic>
c0102971:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102974:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102979:	c9                   	leave  
c010297a:	c3                   	ret    

c010297b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010297b:	55                   	push   %ebp
c010297c:	89 e5                	mov    %esp,%ebp
c010297e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102981:	8b 45 08             	mov    0x8(%ebp),%eax
c0102984:	83 e0 01             	and    $0x1,%eax
c0102987:	85 c0                	test   %eax,%eax
c0102989:	75 14                	jne    c010299f <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010298b:	83 ec 04             	sub    $0x4,%esp
c010298e:	68 24 62 10 c0       	push   $0xc0106224
c0102993:	6a 6c                	push   $0x6c
c0102995:	68 ef 61 10 c0       	push   $0xc01061ef
c010299a:	e8 33 da ff ff       	call   c01003d2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010299f:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01029a7:	83 ec 0c             	sub    $0xc,%esp
c01029aa:	50                   	push   %eax
c01029ab:	e8 3f ff ff ff       	call   c01028ef <pa2page>
c01029b0:	83 c4 10             	add    $0x10,%esp
}
c01029b3:	c9                   	leave  
c01029b4:	c3                   	ret    

c01029b5 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c01029b5:	55                   	push   %ebp
c01029b6:	89 e5                	mov    %esp,%ebp
c01029b8:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c01029bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01029c3:	83 ec 0c             	sub    $0xc,%esp
c01029c6:	50                   	push   %eax
c01029c7:	e8 23 ff ff ff       	call   c01028ef <pa2page>
c01029cc:	83 c4 10             	add    $0x10,%esp
}
c01029cf:	c9                   	leave  
c01029d0:	c3                   	ret    

c01029d1 <page_ref>:

static inline int
page_ref(struct Page *page) {
c01029d1:	55                   	push   %ebp
c01029d2:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d7:	8b 00                	mov    (%eax),%eax
}
c01029d9:	5d                   	pop    %ebp
c01029da:	c3                   	ret    

c01029db <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029db:	55                   	push   %ebp
c01029dc:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029de:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029e4:	89 10                	mov    %edx,(%eax)
}
c01029e6:	90                   	nop
c01029e7:	5d                   	pop    %ebp
c01029e8:	c3                   	ret    

c01029e9 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01029e9:	55                   	push   %ebp
c01029ea:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01029ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ef:	8b 00                	mov    (%eax),%eax
c01029f1:	8d 50 01             	lea    0x1(%eax),%edx
c01029f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029fc:	8b 00                	mov    (%eax),%eax
}
c01029fe:	5d                   	pop    %ebp
c01029ff:	c3                   	ret    

c0102a00 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102a00:	55                   	push   %ebp
c0102a01:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a06:	8b 00                	mov    (%eax),%eax
c0102a08:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102a0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a0e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a13:	8b 00                	mov    (%eax),%eax
}
c0102a15:	5d                   	pop    %ebp
c0102a16:	c3                   	ret    

c0102a17 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0102a17:	55                   	push   %ebp
c0102a18:	89 e5                	mov    %esp,%ebp
c0102a1a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102a1d:	9c                   	pushf  
c0102a1e:	58                   	pop    %eax
c0102a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102a25:	25 00 02 00 00       	and    $0x200,%eax
c0102a2a:	85 c0                	test   %eax,%eax
c0102a2c:	74 0c                	je     c0102a3a <__intr_save+0x23>
        intr_disable();
c0102a2e:	e8 39 ee ff ff       	call   c010186c <intr_disable>
        return 1;
c0102a33:	b8 01 00 00 00       	mov    $0x1,%eax
c0102a38:	eb 05                	jmp    c0102a3f <__intr_save+0x28>
    }
    return 0;
c0102a3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102a3f:	c9                   	leave  
c0102a40:	c3                   	ret    

c0102a41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102a41:	55                   	push   %ebp
c0102a42:	89 e5                	mov    %esp,%ebp
c0102a44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102a47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a4b:	74 05                	je     c0102a52 <__intr_restore+0x11>
        intr_enable();
c0102a4d:	e8 13 ee ff ff       	call   c0101865 <intr_enable>
    }
}
c0102a52:	90                   	nop
c0102a53:	c9                   	leave  
c0102a54:	c3                   	ret    

c0102a55 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102a55:	55                   	push   %ebp
c0102a56:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102a5e:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a63:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102a65:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a6a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102a6c:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a71:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a73:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a78:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a7a:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a7f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a81:	ea 88 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a88
}
c0102a88:	90                   	nop
c0102a89:	5d                   	pop    %ebp
c0102a8a:	c3                   	ret    

c0102a8b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a8b:	55                   	push   %ebp
c0102a8c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a91:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102a96:	90                   	nop
c0102a97:	5d                   	pop    %ebp
c0102a98:	c3                   	ret    

c0102a99 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a99:	55                   	push   %ebp
c0102a9a:	89 e5                	mov    %esp,%ebp
c0102a9c:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a9f:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102aa4:	50                   	push   %eax
c0102aa5:	e8 e1 ff ff ff       	call   c0102a8b <load_esp0>
c0102aaa:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102aad:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102ab4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102ab6:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102abd:	68 00 
c0102abf:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102ac4:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102aca:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102acf:	c1 e8 10             	shr    $0x10,%eax
c0102ad2:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102ad7:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ade:	83 e0 f0             	and    $0xfffffff0,%eax
c0102ae1:	83 c8 09             	or     $0x9,%eax
c0102ae4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ae9:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102af0:	83 e0 ef             	and    $0xffffffef,%eax
c0102af3:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102af8:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102aff:	83 e0 9f             	and    $0xffffff9f,%eax
c0102b02:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b07:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102b0e:	83 c8 80             	or     $0xffffff80,%eax
c0102b11:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102b16:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b1d:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b20:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b25:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b2c:	83 e0 ef             	and    $0xffffffef,%eax
c0102b2f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b34:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b3b:	83 e0 df             	and    $0xffffffdf,%eax
c0102b3e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b43:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b4a:	83 c8 40             	or     $0x40,%eax
c0102b4d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b52:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b59:	83 e0 7f             	and    $0x7f,%eax
c0102b5c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b61:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b66:	c1 e8 18             	shr    $0x18,%eax
c0102b69:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102b6e:	68 30 7a 11 c0       	push   $0xc0117a30
c0102b73:	e8 dd fe ff ff       	call   c0102a55 <lgdt>
c0102b78:	83 c4 04             	add    $0x4,%esp
c0102b7b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b81:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b85:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b88:	90                   	nop
c0102b89:	c9                   	leave  
c0102b8a:	c3                   	ret    

c0102b8b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b8b:	55                   	push   %ebp
c0102b8c:	89 e5                	mov    %esp,%ebp
c0102b8e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b91:	c7 05 50 89 11 c0 98 	movl   $0xc0106b98,0xc0118950
c0102b98:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b9b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102ba0:	8b 00                	mov    (%eax),%eax
c0102ba2:	83 ec 08             	sub    $0x8,%esp
c0102ba5:	50                   	push   %eax
c0102ba6:	68 50 62 10 c0       	push   $0xc0106250
c0102bab:	e8 bc d6 ff ff       	call   c010026c <cprintf>
c0102bb0:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102bb3:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bb8:	8b 40 04             	mov    0x4(%eax),%eax
c0102bbb:	ff d0                	call   *%eax
}
c0102bbd:	90                   	nop
c0102bbe:	c9                   	leave  
c0102bbf:	c3                   	ret    

c0102bc0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102bc0:	55                   	push   %ebp
c0102bc1:	89 e5                	mov    %esp,%ebp
c0102bc3:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102bc6:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bcb:	8b 40 08             	mov    0x8(%eax),%eax
c0102bce:	83 ec 08             	sub    $0x8,%esp
c0102bd1:	ff 75 0c             	pushl  0xc(%ebp)
c0102bd4:	ff 75 08             	pushl  0x8(%ebp)
c0102bd7:	ff d0                	call   *%eax
c0102bd9:	83 c4 10             	add    $0x10,%esp
}
c0102bdc:	90                   	nop
c0102bdd:	c9                   	leave  
c0102bde:	c3                   	ret    

c0102bdf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102bdf:	55                   	push   %ebp
c0102be0:	89 e5                	mov    %esp,%ebp
c0102be2:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102be5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bec:	e8 26 fe ff ff       	call   c0102a17 <__intr_save>
c0102bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102bf4:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bf9:	8b 40 0c             	mov    0xc(%eax),%eax
c0102bfc:	83 ec 0c             	sub    $0xc,%esp
c0102bff:	ff 75 08             	pushl  0x8(%ebp)
c0102c02:	ff d0                	call   *%eax
c0102c04:	83 c4 10             	add    $0x10,%esp
c0102c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c0a:	83 ec 0c             	sub    $0xc,%esp
c0102c0d:	ff 75 f0             	pushl  -0x10(%ebp)
c0102c10:	e8 2c fe ff ff       	call   c0102a41 <__intr_restore>
c0102c15:	83 c4 10             	add    $0x10,%esp
    return page;
c0102c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c1b:	c9                   	leave  
c0102c1c:	c3                   	ret    

c0102c1d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102c1d:	55                   	push   %ebp
c0102c1e:	89 e5                	mov    %esp,%ebp
c0102c20:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c23:	e8 ef fd ff ff       	call   c0102a17 <__intr_save>
c0102c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102c2b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102c30:	8b 40 10             	mov    0x10(%eax),%eax
c0102c33:	83 ec 08             	sub    $0x8,%esp
c0102c36:	ff 75 0c             	pushl  0xc(%ebp)
c0102c39:	ff 75 08             	pushl  0x8(%ebp)
c0102c3c:	ff d0                	call   *%eax
c0102c3e:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102c41:	83 ec 0c             	sub    $0xc,%esp
c0102c44:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c47:	e8 f5 fd ff ff       	call   c0102a41 <__intr_restore>
c0102c4c:	83 c4 10             	add    $0x10,%esp
}
c0102c4f:	90                   	nop
c0102c50:	c9                   	leave  
c0102c51:	c3                   	ret    

c0102c52 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102c52:	55                   	push   %ebp
c0102c53:	89 e5                	mov    %esp,%ebp
c0102c55:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c58:	e8 ba fd ff ff       	call   c0102a17 <__intr_save>
c0102c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102c60:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102c65:	8b 40 14             	mov    0x14(%eax),%eax
c0102c68:	ff d0                	call   *%eax
c0102c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c6d:	83 ec 0c             	sub    $0xc,%esp
c0102c70:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c73:	e8 c9 fd ff ff       	call   c0102a41 <__intr_restore>
c0102c78:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c7e:	c9                   	leave  
c0102c7f:	c3                   	ret    

c0102c80 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c80:	55                   	push   %ebp
c0102c81:	89 e5                	mov    %esp,%ebp
c0102c83:	57                   	push   %edi
c0102c84:	56                   	push   %esi
c0102c85:	53                   	push   %ebx
c0102c86:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c89:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c9e:	83 ec 0c             	sub    $0xc,%esp
c0102ca1:	68 67 62 10 c0       	push   $0xc0106267
c0102ca6:	e8 c1 d5 ff ff       	call   c010026c <cprintf>
c0102cab:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102cae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102cb5:	e9 fc 00 00 00       	jmp    c0102db6 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102cba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cc0:	89 d0                	mov    %edx,%eax
c0102cc2:	c1 e0 02             	shl    $0x2,%eax
c0102cc5:	01 d0                	add    %edx,%eax
c0102cc7:	c1 e0 02             	shl    $0x2,%eax
c0102cca:	01 c8                	add    %ecx,%eax
c0102ccc:	8b 50 08             	mov    0x8(%eax),%edx
c0102ccf:	8b 40 04             	mov    0x4(%eax),%eax
c0102cd2:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102cd5:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102cd8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cde:	89 d0                	mov    %edx,%eax
c0102ce0:	c1 e0 02             	shl    $0x2,%eax
c0102ce3:	01 d0                	add    %edx,%eax
c0102ce5:	c1 e0 02             	shl    $0x2,%eax
c0102ce8:	01 c8                	add    %ecx,%eax
c0102cea:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ced:	8b 58 10             	mov    0x10(%eax),%ebx
c0102cf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102cf3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cf6:	01 c8                	add    %ecx,%eax
c0102cf8:	11 da                	adc    %ebx,%edx
c0102cfa:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102cfd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102d00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d03:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d06:	89 d0                	mov    %edx,%eax
c0102d08:	c1 e0 02             	shl    $0x2,%eax
c0102d0b:	01 d0                	add    %edx,%eax
c0102d0d:	c1 e0 02             	shl    $0x2,%eax
c0102d10:	01 c8                	add    %ecx,%eax
c0102d12:	83 c0 14             	add    $0x14,%eax
c0102d15:	8b 00                	mov    (%eax),%eax
c0102d17:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102d1a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d1d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d20:	83 c0 ff             	add    $0xffffffff,%eax
c0102d23:	83 d2 ff             	adc    $0xffffffff,%edx
c0102d26:	89 c1                	mov    %eax,%ecx
c0102d28:	89 d3                	mov    %edx,%ebx
c0102d2a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d2d:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102d30:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d33:	89 d0                	mov    %edx,%eax
c0102d35:	c1 e0 02             	shl    $0x2,%eax
c0102d38:	01 d0                	add    %edx,%eax
c0102d3a:	c1 e0 02             	shl    $0x2,%eax
c0102d3d:	03 45 80             	add    -0x80(%ebp),%eax
c0102d40:	8b 50 10             	mov    0x10(%eax),%edx
c0102d43:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d46:	ff 75 84             	pushl  -0x7c(%ebp)
c0102d49:	53                   	push   %ebx
c0102d4a:	51                   	push   %ecx
c0102d4b:	ff 75 bc             	pushl  -0x44(%ebp)
c0102d4e:	ff 75 b8             	pushl  -0x48(%ebp)
c0102d51:	52                   	push   %edx
c0102d52:	50                   	push   %eax
c0102d53:	68 74 62 10 c0       	push   $0xc0106274
c0102d58:	e8 0f d5 ff ff       	call   c010026c <cprintf>
c0102d5d:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102d60:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d63:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d66:	89 d0                	mov    %edx,%eax
c0102d68:	c1 e0 02             	shl    $0x2,%eax
c0102d6b:	01 d0                	add    %edx,%eax
c0102d6d:	c1 e0 02             	shl    $0x2,%eax
c0102d70:	01 c8                	add    %ecx,%eax
c0102d72:	83 c0 14             	add    $0x14,%eax
c0102d75:	8b 00                	mov    (%eax),%eax
c0102d77:	83 f8 01             	cmp    $0x1,%eax
c0102d7a:	75 36                	jne    c0102db2 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d82:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d85:	77 2b                	ja     c0102db2 <page_init+0x132>
c0102d87:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d8a:	72 05                	jb     c0102d91 <page_init+0x111>
c0102d8c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d8f:	73 21                	jae    c0102db2 <page_init+0x132>
c0102d91:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d95:	77 1b                	ja     c0102db2 <page_init+0x132>
c0102d97:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d9b:	72 09                	jb     c0102da6 <page_init+0x126>
c0102d9d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102da4:	77 0c                	ja     c0102db2 <page_init+0x132>
                maxpa = end;
c0102da6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102da9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102dac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102daf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102db2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102db6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102db9:	8b 00                	mov    (%eax),%eax
c0102dbb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102dbe:	0f 8f f6 fe ff ff    	jg     c0102cba <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dc8:	72 1d                	jb     c0102de7 <page_init+0x167>
c0102dca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102dce:	77 09                	ja     c0102dd9 <page_init+0x159>
c0102dd0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102dd7:	76 0e                	jbe    c0102de7 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102dd9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102de0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102dea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ded:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102df1:	c1 ea 0c             	shr    $0xc,%edx
c0102df4:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102df9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102e00:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102e05:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102e08:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e0b:	01 d0                	add    %edx,%eax
c0102e0d:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102e10:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e13:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e18:	f7 75 ac             	divl   -0x54(%ebp)
c0102e1b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e1e:	29 d0                	sub    %edx,%eax
c0102e20:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102e25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e2c:	eb 2f                	jmp    c0102e5d <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102e2e:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e37:	89 d0                	mov    %edx,%eax
c0102e39:	c1 e0 02             	shl    $0x2,%eax
c0102e3c:	01 d0                	add    %edx,%eax
c0102e3e:	c1 e0 02             	shl    $0x2,%eax
c0102e41:	01 c8                	add    %ecx,%eax
c0102e43:	83 c0 04             	add    $0x4,%eax
c0102e46:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102e4d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e50:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e53:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e56:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102e59:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e60:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102e65:	39 c2                	cmp    %eax,%edx
c0102e67:	72 c5                	jb     c0102e2e <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e69:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102e6f:	89 d0                	mov    %edx,%eax
c0102e71:	c1 e0 02             	shl    $0x2,%eax
c0102e74:	01 d0                	add    %edx,%eax
c0102e76:	c1 e0 02             	shl    $0x2,%eax
c0102e79:	89 c2                	mov    %eax,%edx
c0102e7b:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e80:	01 d0                	add    %edx,%eax
c0102e82:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e85:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e8c:	77 17                	ja     c0102ea5 <page_init+0x225>
c0102e8e:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e91:	68 a4 62 10 c0       	push   $0xc01062a4
c0102e96:	68 db 00 00 00       	push   $0xdb
c0102e9b:	68 c8 62 10 c0       	push   $0xc01062c8
c0102ea0:	e8 2d d5 ff ff       	call   c01003d2 <__panic>
c0102ea5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102ea8:	05 00 00 00 40       	add    $0x40000000,%eax
c0102ead:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102eb0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102eb7:	e9 69 01 00 00       	jmp    c0103025 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102ebc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ebf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ec2:	89 d0                	mov    %edx,%eax
c0102ec4:	c1 e0 02             	shl    $0x2,%eax
c0102ec7:	01 d0                	add    %edx,%eax
c0102ec9:	c1 e0 02             	shl    $0x2,%eax
c0102ecc:	01 c8                	add    %ecx,%eax
c0102ece:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed1:	8b 40 04             	mov    0x4(%eax),%eax
c0102ed4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ed7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee0:	89 d0                	mov    %edx,%eax
c0102ee2:	c1 e0 02             	shl    $0x2,%eax
c0102ee5:	01 d0                	add    %edx,%eax
c0102ee7:	c1 e0 02             	shl    $0x2,%eax
c0102eea:	01 c8                	add    %ecx,%eax
c0102eec:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102eef:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ef2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ef5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ef8:	01 c8                	add    %ecx,%eax
c0102efa:	11 da                	adc    %ebx,%edx
c0102efc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102eff:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102f02:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f05:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f08:	89 d0                	mov    %edx,%eax
c0102f0a:	c1 e0 02             	shl    $0x2,%eax
c0102f0d:	01 d0                	add    %edx,%eax
c0102f0f:	c1 e0 02             	shl    $0x2,%eax
c0102f12:	01 c8                	add    %ecx,%eax
c0102f14:	83 c0 14             	add    $0x14,%eax
c0102f17:	8b 00                	mov    (%eax),%eax
c0102f19:	83 f8 01             	cmp    $0x1,%eax
c0102f1c:	0f 85 ff 00 00 00    	jne    c0103021 <page_init+0x3a1>
            if (begin < freemem) {
c0102f22:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f25:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f2a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f2d:	72 17                	jb     c0102f46 <page_init+0x2c6>
c0102f2f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f32:	77 05                	ja     c0102f39 <page_init+0x2b9>
c0102f34:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102f37:	76 0d                	jbe    c0102f46 <page_init+0x2c6>
                begin = freemem;
c0102f39:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f3f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102f46:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f4a:	72 1d                	jb     c0102f69 <page_init+0x2e9>
c0102f4c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f50:	77 09                	ja     c0102f5b <page_init+0x2db>
c0102f52:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102f59:	76 0e                	jbe    c0102f69 <page_init+0x2e9>
                end = KMEMSIZE;
c0102f5b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f62:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f69:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f72:	0f 87 a9 00 00 00    	ja     c0103021 <page_init+0x3a1>
c0102f78:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f7b:	72 09                	jb     c0102f86 <page_init+0x306>
c0102f7d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f80:	0f 83 9b 00 00 00    	jae    c0103021 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f86:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f8d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f90:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f93:	01 d0                	add    %edx,%eax
c0102f95:	83 e8 01             	sub    $0x1,%eax
c0102f98:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f9b:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f9e:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fa3:	f7 75 9c             	divl   -0x64(%ebp)
c0102fa6:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102fa9:	29 d0                	sub    %edx,%eax
c0102fab:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fb3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102fb6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fb9:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102fbc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102fbf:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fc4:	89 c3                	mov    %eax,%ebx
c0102fc6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102fcc:	89 de                	mov    %ebx,%esi
c0102fce:	89 d0                	mov    %edx,%eax
c0102fd0:	83 e0 00             	and    $0x0,%eax
c0102fd3:	89 c7                	mov    %eax,%edi
c0102fd5:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102fd8:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102fdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fde:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fe1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fe4:	77 3b                	ja     c0103021 <page_init+0x3a1>
c0102fe6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fe9:	72 05                	jb     c0102ff0 <page_init+0x370>
c0102feb:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102fee:	73 31                	jae    c0103021 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102ff0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ff3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ff6:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102ff9:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102ffc:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103000:	c1 ea 0c             	shr    $0xc,%edx
c0103003:	89 c3                	mov    %eax,%ebx
c0103005:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103008:	83 ec 0c             	sub    $0xc,%esp
c010300b:	50                   	push   %eax
c010300c:	e8 de f8 ff ff       	call   c01028ef <pa2page>
c0103011:	83 c4 10             	add    $0x10,%esp
c0103014:	83 ec 08             	sub    $0x8,%esp
c0103017:	53                   	push   %ebx
c0103018:	50                   	push   %eax
c0103019:	e8 a2 fb ff ff       	call   c0102bc0 <init_memmap>
c010301e:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0103021:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103025:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103028:	8b 00                	mov    (%eax),%eax
c010302a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010302d:	0f 8f 89 fe ff ff    	jg     c0102ebc <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0103033:	90                   	nop
c0103034:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103037:	5b                   	pop    %ebx
c0103038:	5e                   	pop    %esi
c0103039:	5f                   	pop    %edi
c010303a:	5d                   	pop    %ebp
c010303b:	c3                   	ret    

c010303c <enable_paging>:

static void
enable_paging(void) {
c010303c:	55                   	push   %ebp
c010303d:	89 e5                	mov    %esp,%ebp
c010303f:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103042:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0103047:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010304a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010304d:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103050:	0f 20 c0             	mov    %cr0,%eax
c0103053:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103056:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103059:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010305c:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103063:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103067:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010306a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103070:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103073:	90                   	nop
c0103074:	c9                   	leave  
c0103075:	c3                   	ret    

c0103076 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103076:	55                   	push   %ebp
c0103077:	89 e5                	mov    %esp,%ebp
c0103079:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010307c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010307f:	33 45 14             	xor    0x14(%ebp),%eax
c0103082:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103087:	85 c0                	test   %eax,%eax
c0103089:	74 19                	je     c01030a4 <boot_map_segment+0x2e>
c010308b:	68 d6 62 10 c0       	push   $0xc01062d6
c0103090:	68 ed 62 10 c0       	push   $0xc01062ed
c0103095:	68 04 01 00 00       	push   $0x104
c010309a:	68 c8 62 10 c0       	push   $0xc01062c8
c010309f:	e8 2e d3 ff ff       	call   c01003d2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01030a4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01030ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030ae:	25 ff 0f 00 00       	and    $0xfff,%eax
c01030b3:	89 c2                	mov    %eax,%edx
c01030b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01030b8:	01 c2                	add    %eax,%edx
c01030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030bd:	01 d0                	add    %edx,%eax
c01030bf:	83 e8 01             	sub    $0x1,%eax
c01030c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030c8:	ba 00 00 00 00       	mov    $0x0,%edx
c01030cd:	f7 75 f0             	divl   -0x10(%ebp)
c01030d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030d3:	29 d0                	sub    %edx,%eax
c01030d5:	c1 e8 0c             	shr    $0xc,%eax
c01030d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01030db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030e9:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01030ec:	8b 45 14             	mov    0x14(%ebp),%eax
c01030ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01030f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030fa:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030fd:	eb 57                	jmp    c0103156 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01030ff:	83 ec 04             	sub    $0x4,%esp
c0103102:	6a 01                	push   $0x1
c0103104:	ff 75 0c             	pushl  0xc(%ebp)
c0103107:	ff 75 08             	pushl  0x8(%ebp)
c010310a:	e8 98 01 00 00       	call   c01032a7 <get_pte>
c010310f:	83 c4 10             	add    $0x10,%esp
c0103112:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103115:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103119:	75 19                	jne    c0103134 <boot_map_segment+0xbe>
c010311b:	68 02 63 10 c0       	push   $0xc0106302
c0103120:	68 ed 62 10 c0       	push   $0xc01062ed
c0103125:	68 0a 01 00 00       	push   $0x10a
c010312a:	68 c8 62 10 c0       	push   $0xc01062c8
c010312f:	e8 9e d2 ff ff       	call   c01003d2 <__panic>
        *ptep = pa | PTE_P | perm;
c0103134:	8b 45 14             	mov    0x14(%ebp),%eax
c0103137:	0b 45 18             	or     0x18(%ebp),%eax
c010313a:	83 c8 01             	or     $0x1,%eax
c010313d:	89 c2                	mov    %eax,%edx
c010313f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103142:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103144:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103148:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010314f:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010315a:	75 a3                	jne    c01030ff <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010315c:	90                   	nop
c010315d:	c9                   	leave  
c010315e:	c3                   	ret    

c010315f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010315f:	55                   	push   %ebp
c0103160:	89 e5                	mov    %esp,%ebp
c0103162:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c0103165:	83 ec 0c             	sub    $0xc,%esp
c0103168:	6a 01                	push   $0x1
c010316a:	e8 70 fa ff ff       	call   c0102bdf <alloc_pages>
c010316f:	83 c4 10             	add    $0x10,%esp
c0103172:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0103175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103179:	75 17                	jne    c0103192 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c010317b:	83 ec 04             	sub    $0x4,%esp
c010317e:	68 0f 63 10 c0       	push   $0xc010630f
c0103183:	68 16 01 00 00       	push   $0x116
c0103188:	68 c8 62 10 c0       	push   $0xc01062c8
c010318d:	e8 40 d2 ff ff       	call   c01003d2 <__panic>
    }
    return page2kva(p);
c0103192:	83 ec 0c             	sub    $0xc,%esp
c0103195:	ff 75 f4             	pushl  -0xc(%ebp)
c0103198:	e8 99 f7 ff ff       	call   c0102936 <page2kva>
c010319d:	83 c4 10             	add    $0x10,%esp
}
c01031a0:	c9                   	leave  
c01031a1:	c3                   	ret    

c01031a2 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01031a2:	55                   	push   %ebp
c01031a3:	89 e5                	mov    %esp,%ebp
c01031a5:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01031a8:	e8 de f9 ff ff       	call   c0102b8b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01031ad:	e8 ce fa ff ff       	call   c0102c80 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01031b2:	e8 0f 04 00 00       	call   c01035c6 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01031b7:	e8 a3 ff ff ff       	call   c010315f <boot_alloc_page>
c01031bc:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01031c1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031c6:	83 ec 04             	sub    $0x4,%esp
c01031c9:	68 00 10 00 00       	push   $0x1000
c01031ce:	6a 00                	push   $0x0
c01031d0:	50                   	push   %eax
c01031d1:	e8 1a 21 00 00       	call   c01052f0 <memset>
c01031d6:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01031d9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01031e8:	77 17                	ja     c0103201 <pmm_init+0x5f>
c01031ea:	ff 75 f4             	pushl  -0xc(%ebp)
c01031ed:	68 a4 62 10 c0       	push   $0xc01062a4
c01031f2:	68 30 01 00 00       	push   $0x130
c01031f7:	68 c8 62 10 c0       	push   $0xc01062c8
c01031fc:	e8 d1 d1 ff ff       	call   c01003d2 <__panic>
c0103201:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103204:	05 00 00 00 40       	add    $0x40000000,%eax
c0103209:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c010320e:	e8 d6 03 00 00       	call   c01035e9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103213:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103218:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010321e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103223:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103226:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010322d:	77 17                	ja     c0103246 <pmm_init+0xa4>
c010322f:	ff 75 f0             	pushl  -0x10(%ebp)
c0103232:	68 a4 62 10 c0       	push   $0xc01062a4
c0103237:	68 38 01 00 00       	push   $0x138
c010323c:	68 c8 62 10 c0       	push   $0xc01062c8
c0103241:	e8 8c d1 ff ff       	call   c01003d2 <__panic>
c0103246:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103249:	05 00 00 00 40       	add    $0x40000000,%eax
c010324e:	83 c8 03             	or     $0x3,%eax
c0103251:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103253:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103258:	83 ec 0c             	sub    $0xc,%esp
c010325b:	6a 02                	push   $0x2
c010325d:	6a 00                	push   $0x0
c010325f:	68 00 00 00 38       	push   $0x38000000
c0103264:	68 00 00 00 c0       	push   $0xc0000000
c0103269:	50                   	push   %eax
c010326a:	e8 07 fe ff ff       	call   c0103076 <boot_map_segment>
c010326f:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103272:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103277:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010327d:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103283:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0103285:	e8 b2 fd ff ff       	call   c010303c <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010328a:	e8 0a f8 ff ff       	call   c0102a99 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010328f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010329a:	e8 b0 08 00 00       	call   c0103b4f <check_boot_pgdir>

    print_pgdir();
c010329f:	e8 a6 0c 00 00       	call   c0103f4a <print_pgdir>

}
c01032a4:	90                   	nop
c01032a5:	c9                   	leave  
c01032a6:	c3                   	ret    

c01032a7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01032a7:	55                   	push   %ebp
c01032a8:	89 e5                	mov    %esp,%ebp
c01032aa:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01032ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032b0:	c1 e8 16             	shr    $0x16,%eax
c01032b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01032ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01032bd:	01 d0                	add    %edx,%eax
c01032bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c5:	8b 00                	mov    (%eax),%eax
c01032c7:	83 e0 01             	and    $0x1,%eax
c01032ca:	85 c0                	test   %eax,%eax
c01032cc:	0f 85 9f 00 00 00    	jne    c0103371 <get_pte+0xca>
        struct Page *page;
        if(!create || (page = alloc_page()) == NULL) {return NULL;}
c01032d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01032d6:	74 16                	je     c01032ee <get_pte+0x47>
c01032d8:	83 ec 0c             	sub    $0xc,%esp
c01032db:	6a 01                	push   $0x1
c01032dd:	e8 fd f8 ff ff       	call   c0102bdf <alloc_pages>
c01032e2:	83 c4 10             	add    $0x10,%esp
c01032e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032ec:	75 0a                	jne    c01032f8 <get_pte+0x51>
c01032ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01032f3:	e9 ca 00 00 00       	jmp    c01033c2 <get_pte+0x11b>
        set_page_ref(page, 1);
c01032f8:	83 ec 08             	sub    $0x8,%esp
c01032fb:	6a 01                	push   $0x1
c01032fd:	ff 75 f0             	pushl  -0x10(%ebp)
c0103300:	e8 d6 f6 ff ff       	call   c01029db <set_page_ref>
c0103305:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c0103308:	83 ec 0c             	sub    $0xc,%esp
c010330b:	ff 75 f0             	pushl  -0x10(%ebp)
c010330e:	e8 c9 f5 ff ff       	call   c01028dc <page2pa>
c0103313:	83 c4 10             	add    $0x10,%esp
c0103316:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa),0,PGSIZE);
c0103319:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010331c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103322:	c1 e8 0c             	shr    $0xc,%eax
c0103325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103328:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010332d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103330:	72 17                	jb     c0103349 <get_pte+0xa2>
c0103332:	ff 75 e8             	pushl  -0x18(%ebp)
c0103335:	68 00 62 10 c0       	push   $0xc0106200
c010333a:	68 85 01 00 00       	push   $0x185
c010333f:	68 c8 62 10 c0       	push   $0xc01062c8
c0103344:	e8 89 d0 ff ff       	call   c01003d2 <__panic>
c0103349:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010334c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103351:	83 ec 04             	sub    $0x4,%esp
c0103354:	68 00 10 00 00       	push   $0x1000
c0103359:	6a 00                	push   $0x0
c010335b:	50                   	push   %eax
c010335c:	e8 8f 1f 00 00       	call   c01052f0 <memset>
c0103361:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0103364:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103367:	83 c8 07             	or     $0x7,%eax
c010336a:	89 c2                	mov    %eax,%edx
c010336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010336f:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0103371:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103374:	8b 00                	mov    (%eax),%eax
c0103376:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010337b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103381:	c1 e8 0c             	shr    $0xc,%eax
c0103384:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103387:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010338c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010338f:	72 17                	jb     c01033a8 <get_pte+0x101>
c0103391:	ff 75 e0             	pushl  -0x20(%ebp)
c0103394:	68 00 62 10 c0       	push   $0xc0106200
c0103399:	68 88 01 00 00       	push   $0x188
c010339e:	68 c8 62 10 c0       	push   $0xc01062c8
c01033a3:	e8 2a d0 ff ff       	call   c01003d2 <__panic>
c01033a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033ab:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033b0:	89 c2                	mov    %eax,%edx
c01033b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b5:	c1 e8 0c             	shr    $0xc,%eax
c01033b8:	25 ff 03 00 00       	and    $0x3ff,%eax
c01033bd:	c1 e0 02             	shl    $0x2,%eax
c01033c0:	01 d0                	add    %edx,%eax
}
c01033c2:	c9                   	leave  
c01033c3:	c3                   	ret    

c01033c4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01033c4:	55                   	push   %ebp
c01033c5:	89 e5                	mov    %esp,%ebp
c01033c7:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033ca:	83 ec 04             	sub    $0x4,%esp
c01033cd:	6a 00                	push   $0x0
c01033cf:	ff 75 0c             	pushl  0xc(%ebp)
c01033d2:	ff 75 08             	pushl  0x8(%ebp)
c01033d5:	e8 cd fe ff ff       	call   c01032a7 <get_pte>
c01033da:	83 c4 10             	add    $0x10,%esp
c01033dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01033e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033e4:	74 08                	je     c01033ee <get_page+0x2a>
        *ptep_store = ptep;
c01033e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01033e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033ec:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01033ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033f2:	74 1f                	je     c0103413 <get_page+0x4f>
c01033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f7:	8b 00                	mov    (%eax),%eax
c01033f9:	83 e0 01             	and    $0x1,%eax
c01033fc:	85 c0                	test   %eax,%eax
c01033fe:	74 13                	je     c0103413 <get_page+0x4f>
        return pte2page(*ptep);
c0103400:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103403:	8b 00                	mov    (%eax),%eax
c0103405:	83 ec 0c             	sub    $0xc,%esp
c0103408:	50                   	push   %eax
c0103409:	e8 6d f5 ff ff       	call   c010297b <pte2page>
c010340e:	83 c4 10             	add    $0x10,%esp
c0103411:	eb 05                	jmp    c0103418 <get_page+0x54>
    }
    return NULL;
c0103413:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103418:	c9                   	leave  
c0103419:	c3                   	ret    

c010341a <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010341a:	55                   	push   %ebp
c010341b:	89 e5                	mov    %esp,%ebp
c010341d:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P) {
c0103420:	8b 45 10             	mov    0x10(%ebp),%eax
c0103423:	8b 00                	mov    (%eax),%eax
c0103425:	83 e0 01             	and    $0x1,%eax
c0103428:	85 c0                	test   %eax,%eax
c010342a:	74 55                	je     c0103481 <page_remove_pte+0x67>
        struct Page *page = pte2page(*ptep);
c010342c:	8b 45 10             	mov    0x10(%ebp),%eax
c010342f:	8b 00                	mov    (%eax),%eax
c0103431:	83 ec 0c             	sub    $0xc,%esp
c0103434:	50                   	push   %eax
c0103435:	e8 41 f5 ff ff       	call   c010297b <pte2page>
c010343a:	83 c4 10             	add    $0x10,%esp
c010343d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c0103440:	83 ec 0c             	sub    $0xc,%esp
c0103443:	ff 75 f4             	pushl  -0xc(%ebp)
c0103446:	e8 b5 f5 ff ff       	call   c0102a00 <page_ref_dec>
c010344b:	83 c4 10             	add    $0x10,%esp
        if(page->ref == 0) {
c010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103451:	8b 00                	mov    (%eax),%eax
c0103453:	85 c0                	test   %eax,%eax
c0103455:	75 10                	jne    c0103467 <page_remove_pte+0x4d>
            free_page(page);
c0103457:	83 ec 08             	sub    $0x8,%esp
c010345a:	6a 01                	push   $0x1
c010345c:	ff 75 f4             	pushl  -0xc(%ebp)
c010345f:	e8 b9 f7 ff ff       	call   c0102c1d <free_pages>
c0103464:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c0103467:	8b 45 10             	mov    0x10(%ebp),%eax
c010346a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0103470:	83 ec 08             	sub    $0x8,%esp
c0103473:	ff 75 0c             	pushl  0xc(%ebp)
c0103476:	ff 75 08             	pushl  0x8(%ebp)
c0103479:	e8 f8 00 00 00       	call   c0103576 <tlb_invalidate>
c010347e:	83 c4 10             	add    $0x10,%esp
    }
}
c0103481:	90                   	nop
c0103482:	c9                   	leave  
c0103483:	c3                   	ret    

c0103484 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103484:	55                   	push   %ebp
c0103485:	89 e5                	mov    %esp,%ebp
c0103487:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010348a:	83 ec 04             	sub    $0x4,%esp
c010348d:	6a 00                	push   $0x0
c010348f:	ff 75 0c             	pushl  0xc(%ebp)
c0103492:	ff 75 08             	pushl  0x8(%ebp)
c0103495:	e8 0d fe ff ff       	call   c01032a7 <get_pte>
c010349a:	83 c4 10             	add    $0x10,%esp
c010349d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01034a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034a4:	74 14                	je     c01034ba <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01034a6:	83 ec 04             	sub    $0x4,%esp
c01034a9:	ff 75 f4             	pushl  -0xc(%ebp)
c01034ac:	ff 75 0c             	pushl  0xc(%ebp)
c01034af:	ff 75 08             	pushl  0x8(%ebp)
c01034b2:	e8 63 ff ff ff       	call   c010341a <page_remove_pte>
c01034b7:	83 c4 10             	add    $0x10,%esp
    }
}
c01034ba:	90                   	nop
c01034bb:	c9                   	leave  
c01034bc:	c3                   	ret    

c01034bd <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01034bd:	55                   	push   %ebp
c01034be:	89 e5                	mov    %esp,%ebp
c01034c0:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01034c3:	83 ec 04             	sub    $0x4,%esp
c01034c6:	6a 01                	push   $0x1
c01034c8:	ff 75 10             	pushl  0x10(%ebp)
c01034cb:	ff 75 08             	pushl  0x8(%ebp)
c01034ce:	e8 d4 fd ff ff       	call   c01032a7 <get_pte>
c01034d3:	83 c4 10             	add    $0x10,%esp
c01034d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01034d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034dd:	75 0a                	jne    c01034e9 <page_insert+0x2c>
        return -E_NO_MEM;
c01034df:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034e4:	e9 8b 00 00 00       	jmp    c0103574 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034e9:	83 ec 0c             	sub    $0xc,%esp
c01034ec:	ff 75 0c             	pushl  0xc(%ebp)
c01034ef:	e8 f5 f4 ff ff       	call   c01029e9 <page_ref_inc>
c01034f4:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01034f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fa:	8b 00                	mov    (%eax),%eax
c01034fc:	83 e0 01             	and    $0x1,%eax
c01034ff:	85 c0                	test   %eax,%eax
c0103501:	74 40                	je     c0103543 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0103503:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103506:	8b 00                	mov    (%eax),%eax
c0103508:	83 ec 0c             	sub    $0xc,%esp
c010350b:	50                   	push   %eax
c010350c:	e8 6a f4 ff ff       	call   c010297b <pte2page>
c0103511:	83 c4 10             	add    $0x10,%esp
c0103514:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103517:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010351a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010351d:	75 10                	jne    c010352f <page_insert+0x72>
            page_ref_dec(page);
c010351f:	83 ec 0c             	sub    $0xc,%esp
c0103522:	ff 75 0c             	pushl  0xc(%ebp)
c0103525:	e8 d6 f4 ff ff       	call   c0102a00 <page_ref_dec>
c010352a:	83 c4 10             	add    $0x10,%esp
c010352d:	eb 14                	jmp    c0103543 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010352f:	83 ec 04             	sub    $0x4,%esp
c0103532:	ff 75 f4             	pushl  -0xc(%ebp)
c0103535:	ff 75 10             	pushl  0x10(%ebp)
c0103538:	ff 75 08             	pushl  0x8(%ebp)
c010353b:	e8 da fe ff ff       	call   c010341a <page_remove_pte>
c0103540:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103543:	83 ec 0c             	sub    $0xc,%esp
c0103546:	ff 75 0c             	pushl  0xc(%ebp)
c0103549:	e8 8e f3 ff ff       	call   c01028dc <page2pa>
c010354e:	83 c4 10             	add    $0x10,%esp
c0103551:	0b 45 14             	or     0x14(%ebp),%eax
c0103554:	83 c8 01             	or     $0x1,%eax
c0103557:	89 c2                	mov    %eax,%edx
c0103559:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010355c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010355e:	83 ec 08             	sub    $0x8,%esp
c0103561:	ff 75 10             	pushl  0x10(%ebp)
c0103564:	ff 75 08             	pushl  0x8(%ebp)
c0103567:	e8 0a 00 00 00       	call   c0103576 <tlb_invalidate>
c010356c:	83 c4 10             	add    $0x10,%esp
    return 0;
c010356f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103574:	c9                   	leave  
c0103575:	c3                   	ret    

c0103576 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103576:	55                   	push   %ebp
c0103577:	89 e5                	mov    %esp,%ebp
c0103579:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010357c:	0f 20 d8             	mov    %cr3,%eax
c010357f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103582:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103585:	8b 45 08             	mov    0x8(%ebp),%eax
c0103588:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010358b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103592:	77 17                	ja     c01035ab <tlb_invalidate+0x35>
c0103594:	ff 75 f0             	pushl  -0x10(%ebp)
c0103597:	68 a4 62 10 c0       	push   $0xc01062a4
c010359c:	68 eb 01 00 00       	push   $0x1eb
c01035a1:	68 c8 62 10 c0       	push   $0xc01062c8
c01035a6:	e8 27 ce ff ff       	call   c01003d2 <__panic>
c01035ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ae:	05 00 00 00 40       	add    $0x40000000,%eax
c01035b3:	39 c2                	cmp    %eax,%edx
c01035b5:	75 0c                	jne    c01035c3 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c01035b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c0:	0f 01 38             	invlpg (%eax)
    }
}
c01035c3:	90                   	nop
c01035c4:	c9                   	leave  
c01035c5:	c3                   	ret    

c01035c6 <check_alloc_page>:

static void
check_alloc_page(void) {
c01035c6:	55                   	push   %ebp
c01035c7:	89 e5                	mov    %esp,%ebp
c01035c9:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01035cc:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01035d1:	8b 40 18             	mov    0x18(%eax),%eax
c01035d4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01035d6:	83 ec 0c             	sub    $0xc,%esp
c01035d9:	68 28 63 10 c0       	push   $0xc0106328
c01035de:	e8 89 cc ff ff       	call   c010026c <cprintf>
c01035e3:	83 c4 10             	add    $0x10,%esp
}
c01035e6:	90                   	nop
c01035e7:	c9                   	leave  
c01035e8:	c3                   	ret    

c01035e9 <check_pgdir>:

static void
check_pgdir(void) {
c01035e9:	55                   	push   %ebp
c01035ea:	89 e5                	mov    %esp,%ebp
c01035ec:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035ef:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01035f4:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035f9:	76 19                	jbe    c0103614 <check_pgdir+0x2b>
c01035fb:	68 47 63 10 c0       	push   $0xc0106347
c0103600:	68 ed 62 10 c0       	push   $0xc01062ed
c0103605:	68 f8 01 00 00       	push   $0x1f8
c010360a:	68 c8 62 10 c0       	push   $0xc01062c8
c010360f:	e8 be cd ff ff       	call   c01003d2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103614:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103619:	85 c0                	test   %eax,%eax
c010361b:	74 0e                	je     c010362b <check_pgdir+0x42>
c010361d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103622:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103627:	85 c0                	test   %eax,%eax
c0103629:	74 19                	je     c0103644 <check_pgdir+0x5b>
c010362b:	68 64 63 10 c0       	push   $0xc0106364
c0103630:	68 ed 62 10 c0       	push   $0xc01062ed
c0103635:	68 f9 01 00 00       	push   $0x1f9
c010363a:	68 c8 62 10 c0       	push   $0xc01062c8
c010363f:	e8 8e cd ff ff       	call   c01003d2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103644:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103649:	83 ec 04             	sub    $0x4,%esp
c010364c:	6a 00                	push   $0x0
c010364e:	6a 00                	push   $0x0
c0103650:	50                   	push   %eax
c0103651:	e8 6e fd ff ff       	call   c01033c4 <get_page>
c0103656:	83 c4 10             	add    $0x10,%esp
c0103659:	85 c0                	test   %eax,%eax
c010365b:	74 19                	je     c0103676 <check_pgdir+0x8d>
c010365d:	68 9c 63 10 c0       	push   $0xc010639c
c0103662:	68 ed 62 10 c0       	push   $0xc01062ed
c0103667:	68 fa 01 00 00       	push   $0x1fa
c010366c:	68 c8 62 10 c0       	push   $0xc01062c8
c0103671:	e8 5c cd ff ff       	call   c01003d2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103676:	83 ec 0c             	sub    $0xc,%esp
c0103679:	6a 01                	push   $0x1
c010367b:	e8 5f f5 ff ff       	call   c0102bdf <alloc_pages>
c0103680:	83 c4 10             	add    $0x10,%esp
c0103683:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103686:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010368b:	6a 00                	push   $0x0
c010368d:	6a 00                	push   $0x0
c010368f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103692:	50                   	push   %eax
c0103693:	e8 25 fe ff ff       	call   c01034bd <page_insert>
c0103698:	83 c4 10             	add    $0x10,%esp
c010369b:	85 c0                	test   %eax,%eax
c010369d:	74 19                	je     c01036b8 <check_pgdir+0xcf>
c010369f:	68 c4 63 10 c0       	push   $0xc01063c4
c01036a4:	68 ed 62 10 c0       	push   $0xc01062ed
c01036a9:	68 fe 01 00 00       	push   $0x1fe
c01036ae:	68 c8 62 10 c0       	push   $0xc01062c8
c01036b3:	e8 1a cd ff ff       	call   c01003d2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01036b8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036bd:	83 ec 04             	sub    $0x4,%esp
c01036c0:	6a 00                	push   $0x0
c01036c2:	6a 00                	push   $0x0
c01036c4:	50                   	push   %eax
c01036c5:	e8 dd fb ff ff       	call   c01032a7 <get_pte>
c01036ca:	83 c4 10             	add    $0x10,%esp
c01036cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01036d4:	75 19                	jne    c01036ef <check_pgdir+0x106>
c01036d6:	68 f0 63 10 c0       	push   $0xc01063f0
c01036db:	68 ed 62 10 c0       	push   $0xc01062ed
c01036e0:	68 01 02 00 00       	push   $0x201
c01036e5:	68 c8 62 10 c0       	push   $0xc01062c8
c01036ea:	e8 e3 cc ff ff       	call   c01003d2 <__panic>
    assert(pte2page(*ptep) == p1);
c01036ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f2:	8b 00                	mov    (%eax),%eax
c01036f4:	83 ec 0c             	sub    $0xc,%esp
c01036f7:	50                   	push   %eax
c01036f8:	e8 7e f2 ff ff       	call   c010297b <pte2page>
c01036fd:	83 c4 10             	add    $0x10,%esp
c0103700:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103703:	74 19                	je     c010371e <check_pgdir+0x135>
c0103705:	68 1d 64 10 c0       	push   $0xc010641d
c010370a:	68 ed 62 10 c0       	push   $0xc01062ed
c010370f:	68 02 02 00 00       	push   $0x202
c0103714:	68 c8 62 10 c0       	push   $0xc01062c8
c0103719:	e8 b4 cc ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p1) == 1);
c010371e:	83 ec 0c             	sub    $0xc,%esp
c0103721:	ff 75 f4             	pushl  -0xc(%ebp)
c0103724:	e8 a8 f2 ff ff       	call   c01029d1 <page_ref>
c0103729:	83 c4 10             	add    $0x10,%esp
c010372c:	83 f8 01             	cmp    $0x1,%eax
c010372f:	74 19                	je     c010374a <check_pgdir+0x161>
c0103731:	68 33 64 10 c0       	push   $0xc0106433
c0103736:	68 ed 62 10 c0       	push   $0xc01062ed
c010373b:	68 03 02 00 00       	push   $0x203
c0103740:	68 c8 62 10 c0       	push   $0xc01062c8
c0103745:	e8 88 cc ff ff       	call   c01003d2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010374a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010374f:	8b 00                	mov    (%eax),%eax
c0103751:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103756:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103759:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010375c:	c1 e8 0c             	shr    $0xc,%eax
c010375f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103762:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103767:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010376a:	72 17                	jb     c0103783 <check_pgdir+0x19a>
c010376c:	ff 75 ec             	pushl  -0x14(%ebp)
c010376f:	68 00 62 10 c0       	push   $0xc0106200
c0103774:	68 05 02 00 00       	push   $0x205
c0103779:	68 c8 62 10 c0       	push   $0xc01062c8
c010377e:	e8 4f cc ff ff       	call   c01003d2 <__panic>
c0103783:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103786:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010378b:	83 c0 04             	add    $0x4,%eax
c010378e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103791:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103796:	83 ec 04             	sub    $0x4,%esp
c0103799:	6a 00                	push   $0x0
c010379b:	68 00 10 00 00       	push   $0x1000
c01037a0:	50                   	push   %eax
c01037a1:	e8 01 fb ff ff       	call   c01032a7 <get_pte>
c01037a6:	83 c4 10             	add    $0x10,%esp
c01037a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037ac:	74 19                	je     c01037c7 <check_pgdir+0x1de>
c01037ae:	68 48 64 10 c0       	push   $0xc0106448
c01037b3:	68 ed 62 10 c0       	push   $0xc01062ed
c01037b8:	68 06 02 00 00       	push   $0x206
c01037bd:	68 c8 62 10 c0       	push   $0xc01062c8
c01037c2:	e8 0b cc ff ff       	call   c01003d2 <__panic>

    p2 = alloc_page();
c01037c7:	83 ec 0c             	sub    $0xc,%esp
c01037ca:	6a 01                	push   $0x1
c01037cc:	e8 0e f4 ff ff       	call   c0102bdf <alloc_pages>
c01037d1:	83 c4 10             	add    $0x10,%esp
c01037d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01037d7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037dc:	6a 06                	push   $0x6
c01037de:	68 00 10 00 00       	push   $0x1000
c01037e3:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037e6:	50                   	push   %eax
c01037e7:	e8 d1 fc ff ff       	call   c01034bd <page_insert>
c01037ec:	83 c4 10             	add    $0x10,%esp
c01037ef:	85 c0                	test   %eax,%eax
c01037f1:	74 19                	je     c010380c <check_pgdir+0x223>
c01037f3:	68 70 64 10 c0       	push   $0xc0106470
c01037f8:	68 ed 62 10 c0       	push   $0xc01062ed
c01037fd:	68 09 02 00 00       	push   $0x209
c0103802:	68 c8 62 10 c0       	push   $0xc01062c8
c0103807:	e8 c6 cb ff ff       	call   c01003d2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010380c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103811:	83 ec 04             	sub    $0x4,%esp
c0103814:	6a 00                	push   $0x0
c0103816:	68 00 10 00 00       	push   $0x1000
c010381b:	50                   	push   %eax
c010381c:	e8 86 fa ff ff       	call   c01032a7 <get_pte>
c0103821:	83 c4 10             	add    $0x10,%esp
c0103824:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103827:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010382b:	75 19                	jne    c0103846 <check_pgdir+0x25d>
c010382d:	68 a8 64 10 c0       	push   $0xc01064a8
c0103832:	68 ed 62 10 c0       	push   $0xc01062ed
c0103837:	68 0a 02 00 00       	push   $0x20a
c010383c:	68 c8 62 10 c0       	push   $0xc01062c8
c0103841:	e8 8c cb ff ff       	call   c01003d2 <__panic>
    assert(*ptep & PTE_U);
c0103846:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103849:	8b 00                	mov    (%eax),%eax
c010384b:	83 e0 04             	and    $0x4,%eax
c010384e:	85 c0                	test   %eax,%eax
c0103850:	75 19                	jne    c010386b <check_pgdir+0x282>
c0103852:	68 d8 64 10 c0       	push   $0xc01064d8
c0103857:	68 ed 62 10 c0       	push   $0xc01062ed
c010385c:	68 0b 02 00 00       	push   $0x20b
c0103861:	68 c8 62 10 c0       	push   $0xc01062c8
c0103866:	e8 67 cb ff ff       	call   c01003d2 <__panic>
    assert(*ptep & PTE_W);
c010386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010386e:	8b 00                	mov    (%eax),%eax
c0103870:	83 e0 02             	and    $0x2,%eax
c0103873:	85 c0                	test   %eax,%eax
c0103875:	75 19                	jne    c0103890 <check_pgdir+0x2a7>
c0103877:	68 e6 64 10 c0       	push   $0xc01064e6
c010387c:	68 ed 62 10 c0       	push   $0xc01062ed
c0103881:	68 0c 02 00 00       	push   $0x20c
c0103886:	68 c8 62 10 c0       	push   $0xc01062c8
c010388b:	e8 42 cb ff ff       	call   c01003d2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103890:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103895:	8b 00                	mov    (%eax),%eax
c0103897:	83 e0 04             	and    $0x4,%eax
c010389a:	85 c0                	test   %eax,%eax
c010389c:	75 19                	jne    c01038b7 <check_pgdir+0x2ce>
c010389e:	68 f4 64 10 c0       	push   $0xc01064f4
c01038a3:	68 ed 62 10 c0       	push   $0xc01062ed
c01038a8:	68 0d 02 00 00       	push   $0x20d
c01038ad:	68 c8 62 10 c0       	push   $0xc01062c8
c01038b2:	e8 1b cb ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p2) == 1);
c01038b7:	83 ec 0c             	sub    $0xc,%esp
c01038ba:	ff 75 e4             	pushl  -0x1c(%ebp)
c01038bd:	e8 0f f1 ff ff       	call   c01029d1 <page_ref>
c01038c2:	83 c4 10             	add    $0x10,%esp
c01038c5:	83 f8 01             	cmp    $0x1,%eax
c01038c8:	74 19                	je     c01038e3 <check_pgdir+0x2fa>
c01038ca:	68 0a 65 10 c0       	push   $0xc010650a
c01038cf:	68 ed 62 10 c0       	push   $0xc01062ed
c01038d4:	68 0e 02 00 00       	push   $0x20e
c01038d9:	68 c8 62 10 c0       	push   $0xc01062c8
c01038de:	e8 ef ca ff ff       	call   c01003d2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01038e3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038e8:	6a 00                	push   $0x0
c01038ea:	68 00 10 00 00       	push   $0x1000
c01038ef:	ff 75 f4             	pushl  -0xc(%ebp)
c01038f2:	50                   	push   %eax
c01038f3:	e8 c5 fb ff ff       	call   c01034bd <page_insert>
c01038f8:	83 c4 10             	add    $0x10,%esp
c01038fb:	85 c0                	test   %eax,%eax
c01038fd:	74 19                	je     c0103918 <check_pgdir+0x32f>
c01038ff:	68 1c 65 10 c0       	push   $0xc010651c
c0103904:	68 ed 62 10 c0       	push   $0xc01062ed
c0103909:	68 10 02 00 00       	push   $0x210
c010390e:	68 c8 62 10 c0       	push   $0xc01062c8
c0103913:	e8 ba ca ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p1) == 2);
c0103918:	83 ec 0c             	sub    $0xc,%esp
c010391b:	ff 75 f4             	pushl  -0xc(%ebp)
c010391e:	e8 ae f0 ff ff       	call   c01029d1 <page_ref>
c0103923:	83 c4 10             	add    $0x10,%esp
c0103926:	83 f8 02             	cmp    $0x2,%eax
c0103929:	74 19                	je     c0103944 <check_pgdir+0x35b>
c010392b:	68 48 65 10 c0       	push   $0xc0106548
c0103930:	68 ed 62 10 c0       	push   $0xc01062ed
c0103935:	68 11 02 00 00       	push   $0x211
c010393a:	68 c8 62 10 c0       	push   $0xc01062c8
c010393f:	e8 8e ca ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p2) == 0);
c0103944:	83 ec 0c             	sub    $0xc,%esp
c0103947:	ff 75 e4             	pushl  -0x1c(%ebp)
c010394a:	e8 82 f0 ff ff       	call   c01029d1 <page_ref>
c010394f:	83 c4 10             	add    $0x10,%esp
c0103952:	85 c0                	test   %eax,%eax
c0103954:	74 19                	je     c010396f <check_pgdir+0x386>
c0103956:	68 5a 65 10 c0       	push   $0xc010655a
c010395b:	68 ed 62 10 c0       	push   $0xc01062ed
c0103960:	68 12 02 00 00       	push   $0x212
c0103965:	68 c8 62 10 c0       	push   $0xc01062c8
c010396a:	e8 63 ca ff ff       	call   c01003d2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010396f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103974:	83 ec 04             	sub    $0x4,%esp
c0103977:	6a 00                	push   $0x0
c0103979:	68 00 10 00 00       	push   $0x1000
c010397e:	50                   	push   %eax
c010397f:	e8 23 f9 ff ff       	call   c01032a7 <get_pte>
c0103984:	83 c4 10             	add    $0x10,%esp
c0103987:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010398a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010398e:	75 19                	jne    c01039a9 <check_pgdir+0x3c0>
c0103990:	68 a8 64 10 c0       	push   $0xc01064a8
c0103995:	68 ed 62 10 c0       	push   $0xc01062ed
c010399a:	68 13 02 00 00       	push   $0x213
c010399f:	68 c8 62 10 c0       	push   $0xc01062c8
c01039a4:	e8 29 ca ff ff       	call   c01003d2 <__panic>
    assert(pte2page(*ptep) == p1);
c01039a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ac:	8b 00                	mov    (%eax),%eax
c01039ae:	83 ec 0c             	sub    $0xc,%esp
c01039b1:	50                   	push   %eax
c01039b2:	e8 c4 ef ff ff       	call   c010297b <pte2page>
c01039b7:	83 c4 10             	add    $0x10,%esp
c01039ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01039bd:	74 19                	je     c01039d8 <check_pgdir+0x3ef>
c01039bf:	68 1d 64 10 c0       	push   $0xc010641d
c01039c4:	68 ed 62 10 c0       	push   $0xc01062ed
c01039c9:	68 14 02 00 00       	push   $0x214
c01039ce:	68 c8 62 10 c0       	push   $0xc01062c8
c01039d3:	e8 fa c9 ff ff       	call   c01003d2 <__panic>
    assert((*ptep & PTE_U) == 0);
c01039d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039db:	8b 00                	mov    (%eax),%eax
c01039dd:	83 e0 04             	and    $0x4,%eax
c01039e0:	85 c0                	test   %eax,%eax
c01039e2:	74 19                	je     c01039fd <check_pgdir+0x414>
c01039e4:	68 6c 65 10 c0       	push   $0xc010656c
c01039e9:	68 ed 62 10 c0       	push   $0xc01062ed
c01039ee:	68 15 02 00 00       	push   $0x215
c01039f3:	68 c8 62 10 c0       	push   $0xc01062c8
c01039f8:	e8 d5 c9 ff ff       	call   c01003d2 <__panic>

    page_remove(boot_pgdir, 0x0);
c01039fd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a02:	83 ec 08             	sub    $0x8,%esp
c0103a05:	6a 00                	push   $0x0
c0103a07:	50                   	push   %eax
c0103a08:	e8 77 fa ff ff       	call   c0103484 <page_remove>
c0103a0d:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103a10:	83 ec 0c             	sub    $0xc,%esp
c0103a13:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a16:	e8 b6 ef ff ff       	call   c01029d1 <page_ref>
c0103a1b:	83 c4 10             	add    $0x10,%esp
c0103a1e:	83 f8 01             	cmp    $0x1,%eax
c0103a21:	74 19                	je     c0103a3c <check_pgdir+0x453>
c0103a23:	68 33 64 10 c0       	push   $0xc0106433
c0103a28:	68 ed 62 10 c0       	push   $0xc01062ed
c0103a2d:	68 18 02 00 00       	push   $0x218
c0103a32:	68 c8 62 10 c0       	push   $0xc01062c8
c0103a37:	e8 96 c9 ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p2) == 0);
c0103a3c:	83 ec 0c             	sub    $0xc,%esp
c0103a3f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a42:	e8 8a ef ff ff       	call   c01029d1 <page_ref>
c0103a47:	83 c4 10             	add    $0x10,%esp
c0103a4a:	85 c0                	test   %eax,%eax
c0103a4c:	74 19                	je     c0103a67 <check_pgdir+0x47e>
c0103a4e:	68 5a 65 10 c0       	push   $0xc010655a
c0103a53:	68 ed 62 10 c0       	push   $0xc01062ed
c0103a58:	68 19 02 00 00       	push   $0x219
c0103a5d:	68 c8 62 10 c0       	push   $0xc01062c8
c0103a62:	e8 6b c9 ff ff       	call   c01003d2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103a67:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a6c:	83 ec 08             	sub    $0x8,%esp
c0103a6f:	68 00 10 00 00       	push   $0x1000
c0103a74:	50                   	push   %eax
c0103a75:	e8 0a fa ff ff       	call   c0103484 <page_remove>
c0103a7a:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103a7d:	83 ec 0c             	sub    $0xc,%esp
c0103a80:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a83:	e8 49 ef ff ff       	call   c01029d1 <page_ref>
c0103a88:	83 c4 10             	add    $0x10,%esp
c0103a8b:	85 c0                	test   %eax,%eax
c0103a8d:	74 19                	je     c0103aa8 <check_pgdir+0x4bf>
c0103a8f:	68 81 65 10 c0       	push   $0xc0106581
c0103a94:	68 ed 62 10 c0       	push   $0xc01062ed
c0103a99:	68 1c 02 00 00       	push   $0x21c
c0103a9e:	68 c8 62 10 c0       	push   $0xc01062c8
c0103aa3:	e8 2a c9 ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p2) == 0);
c0103aa8:	83 ec 0c             	sub    $0xc,%esp
c0103aab:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103aae:	e8 1e ef ff ff       	call   c01029d1 <page_ref>
c0103ab3:	83 c4 10             	add    $0x10,%esp
c0103ab6:	85 c0                	test   %eax,%eax
c0103ab8:	74 19                	je     c0103ad3 <check_pgdir+0x4ea>
c0103aba:	68 5a 65 10 c0       	push   $0xc010655a
c0103abf:	68 ed 62 10 c0       	push   $0xc01062ed
c0103ac4:	68 1d 02 00 00       	push   $0x21d
c0103ac9:	68 c8 62 10 c0       	push   $0xc01062c8
c0103ace:	e8 ff c8 ff ff       	call   c01003d2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103ad3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ad8:	8b 00                	mov    (%eax),%eax
c0103ada:	83 ec 0c             	sub    $0xc,%esp
c0103add:	50                   	push   %eax
c0103ade:	e8 d2 ee ff ff       	call   c01029b5 <pde2page>
c0103ae3:	83 c4 10             	add    $0x10,%esp
c0103ae6:	83 ec 0c             	sub    $0xc,%esp
c0103ae9:	50                   	push   %eax
c0103aea:	e8 e2 ee ff ff       	call   c01029d1 <page_ref>
c0103aef:	83 c4 10             	add    $0x10,%esp
c0103af2:	83 f8 01             	cmp    $0x1,%eax
c0103af5:	74 19                	je     c0103b10 <check_pgdir+0x527>
c0103af7:	68 94 65 10 c0       	push   $0xc0106594
c0103afc:	68 ed 62 10 c0       	push   $0xc01062ed
c0103b01:	68 1f 02 00 00       	push   $0x21f
c0103b06:	68 c8 62 10 c0       	push   $0xc01062c8
c0103b0b:	e8 c2 c8 ff ff       	call   c01003d2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103b10:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b15:	8b 00                	mov    (%eax),%eax
c0103b17:	83 ec 0c             	sub    $0xc,%esp
c0103b1a:	50                   	push   %eax
c0103b1b:	e8 95 ee ff ff       	call   c01029b5 <pde2page>
c0103b20:	83 c4 10             	add    $0x10,%esp
c0103b23:	83 ec 08             	sub    $0x8,%esp
c0103b26:	6a 01                	push   $0x1
c0103b28:	50                   	push   %eax
c0103b29:	e8 ef f0 ff ff       	call   c0102c1d <free_pages>
c0103b2e:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103b31:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103b3c:	83 ec 0c             	sub    $0xc,%esp
c0103b3f:	68 bb 65 10 c0       	push   $0xc01065bb
c0103b44:	e8 23 c7 ff ff       	call   c010026c <cprintf>
c0103b49:	83 c4 10             	add    $0x10,%esp
}
c0103b4c:	90                   	nop
c0103b4d:	c9                   	leave  
c0103b4e:	c3                   	ret    

c0103b4f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103b4f:	55                   	push   %ebp
c0103b50:	89 e5                	mov    %esp,%ebp
c0103b52:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b5c:	e9 a3 00 00 00       	jmp    c0103c04 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b6a:	c1 e8 0c             	shr    $0xc,%eax
c0103b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b70:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b75:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b78:	72 17                	jb     c0103b91 <check_boot_pgdir+0x42>
c0103b7a:	ff 75 f0             	pushl  -0x10(%ebp)
c0103b7d:	68 00 62 10 c0       	push   $0xc0106200
c0103b82:	68 2b 02 00 00       	push   $0x22b
c0103b87:	68 c8 62 10 c0       	push   $0xc01062c8
c0103b8c:	e8 41 c8 ff ff       	call   c01003d2 <__panic>
c0103b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b94:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b99:	89 c2                	mov    %eax,%edx
c0103b9b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ba0:	83 ec 04             	sub    $0x4,%esp
c0103ba3:	6a 00                	push   $0x0
c0103ba5:	52                   	push   %edx
c0103ba6:	50                   	push   %eax
c0103ba7:	e8 fb f6 ff ff       	call   c01032a7 <get_pte>
c0103bac:	83 c4 10             	add    $0x10,%esp
c0103baf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103bb2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103bb6:	75 19                	jne    c0103bd1 <check_boot_pgdir+0x82>
c0103bb8:	68 d8 65 10 c0       	push   $0xc01065d8
c0103bbd:	68 ed 62 10 c0       	push   $0xc01062ed
c0103bc2:	68 2b 02 00 00       	push   $0x22b
c0103bc7:	68 c8 62 10 c0       	push   $0xc01062c8
c0103bcc:	e8 01 c8 ff ff       	call   c01003d2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103bd4:	8b 00                	mov    (%eax),%eax
c0103bd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bdb:	89 c2                	mov    %eax,%edx
c0103bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103be0:	39 c2                	cmp    %eax,%edx
c0103be2:	74 19                	je     c0103bfd <check_boot_pgdir+0xae>
c0103be4:	68 15 66 10 c0       	push   $0xc0106615
c0103be9:	68 ed 62 10 c0       	push   $0xc01062ed
c0103bee:	68 2c 02 00 00       	push   $0x22c
c0103bf3:	68 c8 62 10 c0       	push   $0xc01062c8
c0103bf8:	e8 d5 c7 ff ff       	call   c01003d2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bfd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c07:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103c0c:	39 c2                	cmp    %eax,%edx
c0103c0e:	0f 82 4d ff ff ff    	jb     c0103b61 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103c14:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c19:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103c1e:	8b 00                	mov    (%eax),%eax
c0103c20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c25:	89 c2                	mov    %eax,%edx
c0103c27:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c2f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103c36:	77 17                	ja     c0103c4f <check_boot_pgdir+0x100>
c0103c38:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103c3b:	68 a4 62 10 c0       	push   $0xc01062a4
c0103c40:	68 2f 02 00 00       	push   $0x22f
c0103c45:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c4a:	e8 83 c7 ff ff       	call   c01003d2 <__panic>
c0103c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c52:	05 00 00 00 40       	add    $0x40000000,%eax
c0103c57:	39 c2                	cmp    %eax,%edx
c0103c59:	74 19                	je     c0103c74 <check_boot_pgdir+0x125>
c0103c5b:	68 2c 66 10 c0       	push   $0xc010662c
c0103c60:	68 ed 62 10 c0       	push   $0xc01062ed
c0103c65:	68 2f 02 00 00       	push   $0x22f
c0103c6a:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c6f:	e8 5e c7 ff ff       	call   c01003d2 <__panic>

    assert(boot_pgdir[0] == 0);
c0103c74:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c79:	8b 00                	mov    (%eax),%eax
c0103c7b:	85 c0                	test   %eax,%eax
c0103c7d:	74 19                	je     c0103c98 <check_boot_pgdir+0x149>
c0103c7f:	68 60 66 10 c0       	push   $0xc0106660
c0103c84:	68 ed 62 10 c0       	push   $0xc01062ed
c0103c89:	68 31 02 00 00       	push   $0x231
c0103c8e:	68 c8 62 10 c0       	push   $0xc01062c8
c0103c93:	e8 3a c7 ff ff       	call   c01003d2 <__panic>

    struct Page *p;
    p = alloc_page();
c0103c98:	83 ec 0c             	sub    $0xc,%esp
c0103c9b:	6a 01                	push   $0x1
c0103c9d:	e8 3d ef ff ff       	call   c0102bdf <alloc_pages>
c0103ca2:	83 c4 10             	add    $0x10,%esp
c0103ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103ca8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103cad:	6a 02                	push   $0x2
c0103caf:	68 00 01 00 00       	push   $0x100
c0103cb4:	ff 75 e0             	pushl  -0x20(%ebp)
c0103cb7:	50                   	push   %eax
c0103cb8:	e8 00 f8 ff ff       	call   c01034bd <page_insert>
c0103cbd:	83 c4 10             	add    $0x10,%esp
c0103cc0:	85 c0                	test   %eax,%eax
c0103cc2:	74 19                	je     c0103cdd <check_boot_pgdir+0x18e>
c0103cc4:	68 74 66 10 c0       	push   $0xc0106674
c0103cc9:	68 ed 62 10 c0       	push   $0xc01062ed
c0103cce:	68 35 02 00 00       	push   $0x235
c0103cd3:	68 c8 62 10 c0       	push   $0xc01062c8
c0103cd8:	e8 f5 c6 ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p) == 1);
c0103cdd:	83 ec 0c             	sub    $0xc,%esp
c0103ce0:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ce3:	e8 e9 ec ff ff       	call   c01029d1 <page_ref>
c0103ce8:	83 c4 10             	add    $0x10,%esp
c0103ceb:	83 f8 01             	cmp    $0x1,%eax
c0103cee:	74 19                	je     c0103d09 <check_boot_pgdir+0x1ba>
c0103cf0:	68 a2 66 10 c0       	push   $0xc01066a2
c0103cf5:	68 ed 62 10 c0       	push   $0xc01062ed
c0103cfa:	68 36 02 00 00       	push   $0x236
c0103cff:	68 c8 62 10 c0       	push   $0xc01062c8
c0103d04:	e8 c9 c6 ff ff       	call   c01003d2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103d09:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103d0e:	6a 02                	push   $0x2
c0103d10:	68 00 11 00 00       	push   $0x1100
c0103d15:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d18:	50                   	push   %eax
c0103d19:	e8 9f f7 ff ff       	call   c01034bd <page_insert>
c0103d1e:	83 c4 10             	add    $0x10,%esp
c0103d21:	85 c0                	test   %eax,%eax
c0103d23:	74 19                	je     c0103d3e <check_boot_pgdir+0x1ef>
c0103d25:	68 b4 66 10 c0       	push   $0xc01066b4
c0103d2a:	68 ed 62 10 c0       	push   $0xc01062ed
c0103d2f:	68 37 02 00 00       	push   $0x237
c0103d34:	68 c8 62 10 c0       	push   $0xc01062c8
c0103d39:	e8 94 c6 ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p) == 2);
c0103d3e:	83 ec 0c             	sub    $0xc,%esp
c0103d41:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d44:	e8 88 ec ff ff       	call   c01029d1 <page_ref>
c0103d49:	83 c4 10             	add    $0x10,%esp
c0103d4c:	83 f8 02             	cmp    $0x2,%eax
c0103d4f:	74 19                	je     c0103d6a <check_boot_pgdir+0x21b>
c0103d51:	68 eb 66 10 c0       	push   $0xc01066eb
c0103d56:	68 ed 62 10 c0       	push   $0xc01062ed
c0103d5b:	68 38 02 00 00       	push   $0x238
c0103d60:	68 c8 62 10 c0       	push   $0xc01062c8
c0103d65:	e8 68 c6 ff ff       	call   c01003d2 <__panic>

    const char *str = "ucore: Hello world!!";
c0103d6a:	c7 45 dc fc 66 10 c0 	movl   $0xc01066fc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103d71:	83 ec 08             	sub    $0x8,%esp
c0103d74:	ff 75 dc             	pushl  -0x24(%ebp)
c0103d77:	68 00 01 00 00       	push   $0x100
c0103d7c:	e8 96 12 00 00       	call   c0105017 <strcpy>
c0103d81:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103d84:	83 ec 08             	sub    $0x8,%esp
c0103d87:	68 00 11 00 00       	push   $0x1100
c0103d8c:	68 00 01 00 00       	push   $0x100
c0103d91:	e8 fb 12 00 00       	call   c0105091 <strcmp>
c0103d96:	83 c4 10             	add    $0x10,%esp
c0103d99:	85 c0                	test   %eax,%eax
c0103d9b:	74 19                	je     c0103db6 <check_boot_pgdir+0x267>
c0103d9d:	68 14 67 10 c0       	push   $0xc0106714
c0103da2:	68 ed 62 10 c0       	push   $0xc01062ed
c0103da7:	68 3c 02 00 00       	push   $0x23c
c0103dac:	68 c8 62 10 c0       	push   $0xc01062c8
c0103db1:	e8 1c c6 ff ff       	call   c01003d2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103db6:	83 ec 0c             	sub    $0xc,%esp
c0103db9:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dbc:	e8 75 eb ff ff       	call   c0102936 <page2kva>
c0103dc1:	83 c4 10             	add    $0x10,%esp
c0103dc4:	05 00 01 00 00       	add    $0x100,%eax
c0103dc9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103dcc:	83 ec 0c             	sub    $0xc,%esp
c0103dcf:	68 00 01 00 00       	push   $0x100
c0103dd4:	e8 e6 11 00 00       	call   c0104fbf <strlen>
c0103dd9:	83 c4 10             	add    $0x10,%esp
c0103ddc:	85 c0                	test   %eax,%eax
c0103dde:	74 19                	je     c0103df9 <check_boot_pgdir+0x2aa>
c0103de0:	68 4c 67 10 c0       	push   $0xc010674c
c0103de5:	68 ed 62 10 c0       	push   $0xc01062ed
c0103dea:	68 3f 02 00 00       	push   $0x23f
c0103def:	68 c8 62 10 c0       	push   $0xc01062c8
c0103df4:	e8 d9 c5 ff ff       	call   c01003d2 <__panic>

    free_page(p);
c0103df9:	83 ec 08             	sub    $0x8,%esp
c0103dfc:	6a 01                	push   $0x1
c0103dfe:	ff 75 e0             	pushl  -0x20(%ebp)
c0103e01:	e8 17 ee ff ff       	call   c0102c1d <free_pages>
c0103e06:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103e09:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103e0e:	8b 00                	mov    (%eax),%eax
c0103e10:	83 ec 0c             	sub    $0xc,%esp
c0103e13:	50                   	push   %eax
c0103e14:	e8 9c eb ff ff       	call   c01029b5 <pde2page>
c0103e19:	83 c4 10             	add    $0x10,%esp
c0103e1c:	83 ec 08             	sub    $0x8,%esp
c0103e1f:	6a 01                	push   $0x1
c0103e21:	50                   	push   %eax
c0103e22:	e8 f6 ed ff ff       	call   c0102c1d <free_pages>
c0103e27:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103e2a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103e35:	83 ec 0c             	sub    $0xc,%esp
c0103e38:	68 70 67 10 c0       	push   $0xc0106770
c0103e3d:	e8 2a c4 ff ff       	call   c010026c <cprintf>
c0103e42:	83 c4 10             	add    $0x10,%esp
}
c0103e45:	90                   	nop
c0103e46:	c9                   	leave  
c0103e47:	c3                   	ret    

c0103e48 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103e48:	55                   	push   %ebp
c0103e49:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e4e:	83 e0 04             	and    $0x4,%eax
c0103e51:	85 c0                	test   %eax,%eax
c0103e53:	74 07                	je     c0103e5c <perm2str+0x14>
c0103e55:	b8 75 00 00 00       	mov    $0x75,%eax
c0103e5a:	eb 05                	jmp    c0103e61 <perm2str+0x19>
c0103e5c:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e61:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103e66:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103e6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e70:	83 e0 02             	and    $0x2,%eax
c0103e73:	85 c0                	test   %eax,%eax
c0103e75:	74 07                	je     c0103e7e <perm2str+0x36>
c0103e77:	b8 77 00 00 00       	mov    $0x77,%eax
c0103e7c:	eb 05                	jmp    c0103e83 <perm2str+0x3b>
c0103e7e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e83:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103e88:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103e8f:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103e94:	5d                   	pop    %ebp
c0103e95:	c3                   	ret    

c0103e96 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103e96:	55                   	push   %ebp
c0103e97:	89 e5                	mov    %esp,%ebp
c0103e99:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103e9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ea2:	72 0e                	jb     c0103eb2 <get_pgtable_items+0x1c>
        return 0;
c0103ea4:	b8 00 00 00 00       	mov    $0x0,%eax
c0103ea9:	e9 9a 00 00 00       	jmp    c0103f48 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103eae:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103eb2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103eb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103eb8:	73 18                	jae    c0103ed2 <get_pgtable_items+0x3c>
c0103eba:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ebd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ec4:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ec7:	01 d0                	add    %edx,%eax
c0103ec9:	8b 00                	mov    (%eax),%eax
c0103ecb:	83 e0 01             	and    $0x1,%eax
c0103ece:	85 c0                	test   %eax,%eax
c0103ed0:	74 dc                	je     c0103eae <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103ed2:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ed5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ed8:	73 69                	jae    c0103f43 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103eda:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103ede:	74 08                	je     c0103ee8 <get_pgtable_items+0x52>
            *left_store = start;
c0103ee0:	8b 45 18             	mov    0x18(%ebp),%eax
c0103ee3:	8b 55 10             	mov    0x10(%ebp),%edx
c0103ee6:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103ee8:	8b 45 10             	mov    0x10(%ebp),%eax
c0103eeb:	8d 50 01             	lea    0x1(%eax),%edx
c0103eee:	89 55 10             	mov    %edx,0x10(%ebp)
c0103ef1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ef8:	8b 45 14             	mov    0x14(%ebp),%eax
c0103efb:	01 d0                	add    %edx,%eax
c0103efd:	8b 00                	mov    (%eax),%eax
c0103eff:	83 e0 07             	and    $0x7,%eax
c0103f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f05:	eb 04                	jmp    c0103f0b <get_pgtable_items+0x75>
            start ++;
c0103f07:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f0e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f11:	73 1d                	jae    c0103f30 <get_pgtable_items+0x9a>
c0103f13:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f1d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f20:	01 d0                	add    %edx,%eax
c0103f22:	8b 00                	mov    (%eax),%eax
c0103f24:	83 e0 07             	and    $0x7,%eax
c0103f27:	89 c2                	mov    %eax,%edx
c0103f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f2c:	39 c2                	cmp    %eax,%edx
c0103f2e:	74 d7                	je     c0103f07 <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103f30:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103f34:	74 08                	je     c0103f3e <get_pgtable_items+0xa8>
            *right_store = start;
c0103f36:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103f39:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f3c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f41:	eb 05                	jmp    c0103f48 <get_pgtable_items+0xb2>
    }
    return 0;
c0103f43:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f48:	c9                   	leave  
c0103f49:	c3                   	ret    

c0103f4a <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103f4a:	55                   	push   %ebp
c0103f4b:	89 e5                	mov    %esp,%ebp
c0103f4d:	57                   	push   %edi
c0103f4e:	56                   	push   %esi
c0103f4f:	53                   	push   %ebx
c0103f50:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103f53:	83 ec 0c             	sub    $0xc,%esp
c0103f56:	68 90 67 10 c0       	push   $0xc0106790
c0103f5b:	e8 0c c3 ff ff       	call   c010026c <cprintf>
c0103f60:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103f63:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103f6a:	e9 e5 00 00 00       	jmp    c0104054 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f72:	83 ec 0c             	sub    $0xc,%esp
c0103f75:	50                   	push   %eax
c0103f76:	e8 cd fe ff ff       	call   c0103e48 <perm2str>
c0103f7b:	83 c4 10             	add    $0x10,%esp
c0103f7e:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103f80:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f83:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f86:	29 c2                	sub    %eax,%edx
c0103f88:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f8a:	c1 e0 16             	shl    $0x16,%eax
c0103f8d:	89 c3                	mov    %eax,%ebx
c0103f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f92:	c1 e0 16             	shl    $0x16,%eax
c0103f95:	89 c1                	mov    %eax,%ecx
c0103f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f9a:	c1 e0 16             	shl    $0x16,%eax
c0103f9d:	89 c2                	mov    %eax,%edx
c0103f9f:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fa5:	29 c6                	sub    %eax,%esi
c0103fa7:	89 f0                	mov    %esi,%eax
c0103fa9:	83 ec 08             	sub    $0x8,%esp
c0103fac:	57                   	push   %edi
c0103fad:	53                   	push   %ebx
c0103fae:	51                   	push   %ecx
c0103faf:	52                   	push   %edx
c0103fb0:	50                   	push   %eax
c0103fb1:	68 c1 67 10 c0       	push   $0xc01067c1
c0103fb6:	e8 b1 c2 ff ff       	call   c010026c <cprintf>
c0103fbb:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103fbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fc1:	c1 e0 0a             	shl    $0xa,%eax
c0103fc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103fc7:	eb 4f                	jmp    c0104018 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fcc:	83 ec 0c             	sub    $0xc,%esp
c0103fcf:	50                   	push   %eax
c0103fd0:	e8 73 fe ff ff       	call   c0103e48 <perm2str>
c0103fd5:	83 c4 10             	add    $0x10,%esp
c0103fd8:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103fda:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fe0:	29 c2                	sub    %eax,%edx
c0103fe2:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103fe4:	c1 e0 0c             	shl    $0xc,%eax
c0103fe7:	89 c3                	mov    %eax,%ebx
c0103fe9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103fec:	c1 e0 0c             	shl    $0xc,%eax
c0103fef:	89 c1                	mov    %eax,%ecx
c0103ff1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103ff4:	c1 e0 0c             	shl    $0xc,%eax
c0103ff7:	89 c2                	mov    %eax,%edx
c0103ff9:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103ffc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fff:	29 c6                	sub    %eax,%esi
c0104001:	89 f0                	mov    %esi,%eax
c0104003:	83 ec 08             	sub    $0x8,%esp
c0104006:	57                   	push   %edi
c0104007:	53                   	push   %ebx
c0104008:	51                   	push   %ecx
c0104009:	52                   	push   %edx
c010400a:	50                   	push   %eax
c010400b:	68 e0 67 10 c0       	push   $0xc01067e0
c0104010:	e8 57 c2 ff ff       	call   c010026c <cprintf>
c0104015:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104018:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c010401d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104020:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104023:	89 d3                	mov    %edx,%ebx
c0104025:	c1 e3 0a             	shl    $0xa,%ebx
c0104028:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010402b:	89 d1                	mov    %edx,%ecx
c010402d:	c1 e1 0a             	shl    $0xa,%ecx
c0104030:	83 ec 08             	sub    $0x8,%esp
c0104033:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104036:	52                   	push   %edx
c0104037:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010403a:	52                   	push   %edx
c010403b:	56                   	push   %esi
c010403c:	50                   	push   %eax
c010403d:	53                   	push   %ebx
c010403e:	51                   	push   %ecx
c010403f:	e8 52 fe ff ff       	call   c0103e96 <get_pgtable_items>
c0104044:	83 c4 20             	add    $0x20,%esp
c0104047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010404a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010404e:	0f 85 75 ff ff ff    	jne    c0103fc9 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104054:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104059:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010405c:	83 ec 08             	sub    $0x8,%esp
c010405f:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104062:	52                   	push   %edx
c0104063:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104066:	52                   	push   %edx
c0104067:	51                   	push   %ecx
c0104068:	50                   	push   %eax
c0104069:	68 00 04 00 00       	push   $0x400
c010406e:	6a 00                	push   $0x0
c0104070:	e8 21 fe ff ff       	call   c0103e96 <get_pgtable_items>
c0104075:	83 c4 20             	add    $0x20,%esp
c0104078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010407b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010407f:	0f 85 ea fe ff ff    	jne    c0103f6f <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104085:	83 ec 0c             	sub    $0xc,%esp
c0104088:	68 04 68 10 c0       	push   $0xc0106804
c010408d:	e8 da c1 ff ff       	call   c010026c <cprintf>
c0104092:	83 c4 10             	add    $0x10,%esp
}
c0104095:	90                   	nop
c0104096:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104099:	5b                   	pop    %ebx
c010409a:	5e                   	pop    %esi
c010409b:	5f                   	pop    %edi
c010409c:	5d                   	pop    %ebp
c010409d:	c3                   	ret    

c010409e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010409e:	55                   	push   %ebp
c010409f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01040a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01040a4:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01040aa:	29 d0                	sub    %edx,%eax
c01040ac:	c1 f8 02             	sar    $0x2,%eax
c01040af:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01040b5:	5d                   	pop    %ebp
c01040b6:	c3                   	ret    

c01040b7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01040b7:	55                   	push   %ebp
c01040b8:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01040ba:	ff 75 08             	pushl  0x8(%ebp)
c01040bd:	e8 dc ff ff ff       	call   c010409e <page2ppn>
c01040c2:	83 c4 04             	add    $0x4,%esp
c01040c5:	c1 e0 0c             	shl    $0xc,%eax
}
c01040c8:	c9                   	leave  
c01040c9:	c3                   	ret    

c01040ca <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01040ca:	55                   	push   %ebp
c01040cb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01040cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01040d0:	8b 00                	mov    (%eax),%eax
}
c01040d2:	5d                   	pop    %ebp
c01040d3:	c3                   	ret    

c01040d4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01040d4:	55                   	push   %ebp
c01040d5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01040d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01040da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040dd:	89 10                	mov    %edx,(%eax)
}
c01040df:	90                   	nop
c01040e0:	5d                   	pop    %ebp
c01040e1:	c3                   	ret    

c01040e2 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01040e2:	55                   	push   %ebp
c01040e3:	89 e5                	mov    %esp,%ebp
c01040e5:	83 ec 10             	sub    $0x10,%esp
c01040e8:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01040ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01040f5:	89 50 04             	mov    %edx,0x4(%eax)
c01040f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040fb:	8b 50 04             	mov    0x4(%eax),%edx
c01040fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104101:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104103:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c010410a:	00 00 00 
}
c010410d:	90                   	nop
c010410e:	c9                   	leave  
c010410f:	c3                   	ret    

c0104110 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104110:	55                   	push   %ebp
c0104111:	89 e5                	mov    %esp,%ebp
c0104113:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c0104116:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010411a:	75 16                	jne    c0104132 <default_init_memmap+0x22>
c010411c:	68 38 68 10 c0       	push   $0xc0106838
c0104121:	68 3e 68 10 c0       	push   $0xc010683e
c0104126:	6a 46                	push   $0x46
c0104128:	68 53 68 10 c0       	push   $0xc0106853
c010412d:	e8 a0 c2 ff ff       	call   c01003d2 <__panic>
    struct Page *p = base;
c0104132:	8b 45 08             	mov    0x8(%ebp),%eax
c0104135:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104138:	e9 cb 00 00 00       	jmp    c0104208 <default_init_memmap+0xf8>
        assert(PageReserved(p));
c010413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104140:	83 c0 04             	add    $0x4,%eax
c0104143:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010414a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010414d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104150:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104153:	0f a3 10             	bt     %edx,(%eax)
c0104156:	19 c0                	sbb    %eax,%eax
c0104158:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c010415b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010415f:	0f 95 c0             	setne  %al
c0104162:	0f b6 c0             	movzbl %al,%eax
c0104165:	85 c0                	test   %eax,%eax
c0104167:	75 16                	jne    c010417f <default_init_memmap+0x6f>
c0104169:	68 69 68 10 c0       	push   $0xc0106869
c010416e:	68 3e 68 10 c0       	push   $0xc010683e
c0104173:	6a 49                	push   $0x49
c0104175:	68 53 68 10 c0       	push   $0xc0106853
c010417a:	e8 53 c2 ff ff       	call   c01003d2 <__panic>
        p->flags = 0;
c010417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0104189:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010418c:	83 c0 04             	add    $0x4,%eax
c010418f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104196:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104199:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010419c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010419f:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01041a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01041ac:	83 ec 08             	sub    $0x8,%esp
c01041af:	6a 00                	push   $0x0
c01041b1:	ff 75 f4             	pushl  -0xc(%ebp)
c01041b4:	e8 1b ff ff ff       	call   c01040d4 <set_page_ref>
c01041b9:	83 c4 10             	add    $0x10,%esp
        list_add_before(&free_list, &(p->page_link));
c01041bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041bf:	83 c0 0c             	add    $0xc,%eax
c01041c2:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
c01041c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01041cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041cf:	8b 00                	mov    (%eax),%eax
c01041d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041d4:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01041d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01041da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01041e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01041e6:	89 10                	mov    %edx,(%eax)
c01041e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041eb:	8b 10                	mov    (%eax),%edx
c01041ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01041f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01041fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104202:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104204:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104208:	8b 55 0c             	mov    0xc(%ebp),%edx
c010420b:	89 d0                	mov    %edx,%eax
c010420d:	c1 e0 02             	shl    $0x2,%eax
c0104210:	01 d0                	add    %edx,%eax
c0104212:	c1 e0 02             	shl    $0x2,%eax
c0104215:	89 c2                	mov    %eax,%edx
c0104217:	8b 45 08             	mov    0x8(%ebp),%eax
c010421a:	01 d0                	add    %edx,%eax
c010421c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010421f:	0f 85 18 ff ff ff    	jne    c010413d <default_init_memmap+0x2d>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0104225:	8b 45 08             	mov    0x8(%ebp),%eax
c0104228:	8b 55 0c             	mov    0xc(%ebp),%edx
c010422b:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c010422e:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c0104234:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104237:	01 d0                	add    %edx,%eax
c0104239:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c010423e:	90                   	nop
c010423f:	c9                   	leave  
c0104240:	c3                   	ret    

c0104241 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104241:	55                   	push   %ebp
c0104242:	89 e5                	mov    %esp,%ebp
c0104244:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0104247:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010424b:	75 16                	jne    c0104263 <default_alloc_pages+0x22>
c010424d:	68 38 68 10 c0       	push   $0xc0106838
c0104252:	68 3e 68 10 c0       	push   $0xc010683e
c0104257:	6a 56                	push   $0x56
c0104259:	68 53 68 10 c0       	push   $0xc0106853
c010425e:	e8 6f c1 ff ff       	call   c01003d2 <__panic>
    if (n > nr_free) {
c0104263:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104268:	3b 45 08             	cmp    0x8(%ebp),%eax
c010426b:	73 0a                	jae    c0104277 <default_alloc_pages+0x36>
        return NULL;
c010426d:	b8 00 00 00 00       	mov    $0x0,%eax
c0104272:	e9 37 01 00 00       	jmp    c01043ae <default_alloc_pages+0x16d>
    }
    list_entry_t *le = &free_list;
c0104277:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    list_entry_t *len;
    while ((le = list_next(le)) != &free_list) {
c010427e:	e9 0a 01 00 00       	jmp    c010438d <default_alloc_pages+0x14c>
        struct Page *p = le2page(le, page_link);
c0104283:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104286:	83 e8 0c             	sub    $0xc,%eax
c0104289:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010428c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010428f:	8b 40 08             	mov    0x8(%eax),%eax
c0104292:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104295:	0f 82 f2 00 00 00    	jb     c010438d <default_alloc_pages+0x14c>
            for (int i = 0; i < n; ++i) {
c010429b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01042a2:	eb 7c                	jmp    c0104320 <default_alloc_pages+0xdf>
c01042a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01042aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01042ad:	8b 40 04             	mov    0x4(%eax),%eax
                len = list_next(le);
c01042b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                struct Page *pp = le2page(le, page_link);
c01042b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b6:	83 e8 0c             	sub    $0xc,%eax
c01042b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
                SetPageReserved(pp);
c01042bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042bf:	83 c0 04             	add    $0x4,%eax
c01042c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c01042c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01042cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01042cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042d2:	0f ab 10             	bts    %edx,(%eax)
                ClearPageProperty(pp);
c01042d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042d8:	83 c0 04             	add    $0x4,%eax
c01042db:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01042e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01042e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042eb:	0f b3 10             	btr    %edx,(%eax)
c01042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01042f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042f7:	8b 40 04             	mov    0x4(%eax),%eax
c01042fa:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042fd:	8b 12                	mov    (%edx),%edx
c01042ff:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104302:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104305:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104308:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010430b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010430e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104311:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104314:	89 10                	mov    %edx,(%eax)
                list_del(le);
                le = len;
c0104316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104319:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
    list_entry_t *len;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            for (int i = 0; i < n; ++i) {
c010431c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0104320:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104323:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104326:	0f 82 78 ff ff ff    	jb     c01042a4 <default_alloc_pages+0x63>
                SetPageReserved(pp);
                ClearPageProperty(pp);
                list_del(le);
                le = len;
            }
            if(p->property > n) {
c010432c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010432f:	8b 40 08             	mov    0x8(%eax),%eax
c0104332:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104335:	76 12                	jbe    c0104349 <default_alloc_pages+0x108>
                (le2page(le, page_link))->property = p->property - n;
c0104337:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433a:	8d 50 f4             	lea    -0xc(%eax),%edx
c010433d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104340:	8b 40 08             	mov    0x8(%eax),%eax
c0104343:	2b 45 08             	sub    0x8(%ebp),%eax
c0104346:	89 42 08             	mov    %eax,0x8(%edx)
            }
            ClearPageProperty(p);
c0104349:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010434c:	83 c0 04             	add    $0x4,%eax
c010434f:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104356:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104359:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010435c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010435f:	0f b3 10             	btr    %edx,(%eax)
	    SetPageReserved(p);
c0104362:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104365:	83 c0 04             	add    $0x4,%eax
c0104368:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010436f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104372:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104375:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104378:	0f ab 10             	bts    %edx,(%eax)
            nr_free -= n;
c010437b:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104380:	2b 45 08             	sub    0x8(%ebp),%eax
c0104383:	a3 64 89 11 c0       	mov    %eax,0xc0118964
            return p;
c0104388:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010438b:	eb 21                	jmp    c01043ae <default_alloc_pages+0x16d>
c010438d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104390:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104393:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104396:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le = &free_list;
    list_entry_t *len;
    while ((le = list_next(le)) != &free_list) {
c0104399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010439c:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c01043a3:	0f 85 da fe ff ff    	jne    c0104283 <default_alloc_pages+0x42>
	    SetPageReserved(p);
            nr_free -= n;
            return p;
        }
    }
    return NULL;
c01043a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01043ae:	c9                   	leave  
c01043af:	c3                   	ret    

c01043b0 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01043b0:	55                   	push   %ebp
c01043b1:	89 e5                	mov    %esp,%ebp
c01043b3:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01043b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01043ba:	75 16                	jne    c01043d2 <default_free_pages+0x22>
c01043bc:	68 38 68 10 c0       	push   $0xc0106838
c01043c1:	68 3e 68 10 c0       	push   $0xc010683e
c01043c6:	6a 75                	push   $0x75
c01043c8:	68 53 68 10 c0       	push   $0xc0106853
c01043cd:	e8 00 c0 ff ff       	call   c01003d2 <__panic>
    assert(PageReserved(base));
c01043d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d5:	83 c0 04             	add    $0x4,%eax
c01043d8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c01043df:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043e8:	0f a3 10             	bt     %edx,(%eax)
c01043eb:	19 c0                	sbb    %eax,%eax
c01043ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
c01043f0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01043f4:	0f 95 c0             	setne  %al
c01043f7:	0f b6 c0             	movzbl %al,%eax
c01043fa:	85 c0                	test   %eax,%eax
c01043fc:	75 16                	jne    c0104414 <default_free_pages+0x64>
c01043fe:	68 79 68 10 c0       	push   $0xc0106879
c0104403:	68 3e 68 10 c0       	push   $0xc010683e
c0104408:	6a 76                	push   $0x76
c010440a:	68 53 68 10 c0       	push   $0xc0106853
c010440f:	e8 be bf ff ff       	call   c01003d2 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
c0104414:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
    while( (le = list_next(le))!= &free_list) {
c010441b:	eb 11                	jmp    c010442e <default_free_pages+0x7e>
        p = le2page(le, page_link);
c010441d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104420:	83 e8 0c             	sub    $0xc,%eax
c0104423:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p > base) {break;}
c0104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104429:	3b 45 08             	cmp    0x8(%ebp),%eax
c010442c:	77 1a                	ja     c0104448 <default_free_pages+0x98>
c010442e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104431:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104434:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104437:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    struct Page *p;
    list_entry_t *le = &free_list;
    while( (le = list_next(le))!= &free_list) {
c010443a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010443d:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c0104444:	75 d7                	jne    c010441d <default_free_pages+0x6d>
c0104446:	eb 01                	jmp    c0104449 <default_free_pages+0x99>
        p = le2page(le, page_link);
        if(p > base) {break;}
c0104448:	90                   	nop
    }
    for (p=base; p < base + n; ++p) {
c0104449:	8b 45 08             	mov    0x8(%ebp),%eax
c010444c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010444f:	eb 4b                	jmp    c010449c <default_free_pages+0xec>
        //p->flags = 0;
        //p->property = 0;
        //SetPageProperty(p);
        //set_page_ref(p,0);
        list_add_before(le, &(p->page_link));
c0104451:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104454:	8d 50 0c             	lea    0xc(%eax),%edx
c0104457:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010445a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010445d:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104460:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104463:	8b 00                	mov    (%eax),%eax
c0104465:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104468:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010446b:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010446e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104471:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104474:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104477:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010447a:	89 10                	mov    %edx,(%eax)
c010447c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010447f:	8b 10                	mov    (%eax),%edx
c0104481:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104484:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104487:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010448a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010448d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104490:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104493:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104496:	89 10                	mov    %edx,(%eax)
    list_entry_t *le = &free_list;
    while( (le = list_next(le))!= &free_list) {
        p = le2page(le, page_link);
        if(p > base) {break;}
    }
    for (p=base; p < base + n; ++p) {
c0104498:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010449c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010449f:	89 d0                	mov    %edx,%eax
c01044a1:	c1 e0 02             	shl    $0x2,%eax
c01044a4:	01 d0                	add    %edx,%eax
c01044a6:	c1 e0 02             	shl    $0x2,%eax
c01044a9:	89 c2                	mov    %eax,%edx
c01044ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ae:	01 d0                	add    %edx,%eax
c01044b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01044b3:	77 9c                	ja     c0104451 <default_free_pages+0xa1>
        //p->property = 0;
        //SetPageProperty(p);
        //set_page_ref(p,0);
        list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c01044b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c01044bf:	83 ec 08             	sub    $0x8,%esp
c01044c2:	6a 00                	push   $0x0
c01044c4:	ff 75 08             	pushl  0x8(%ebp)
c01044c7:	e8 08 fc ff ff       	call   c01040d4 <set_page_ref>
c01044cc:	83 c4 10             	add    $0x10,%esp
    ClearPageProperty(base);
c01044cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d2:	83 c0 04             	add    $0x4,%eax
c01044d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01044dc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044df:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01044e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044e5:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01044e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044eb:	83 c0 04             	add    $0x4,%eax
c01044ee:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01044f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01044fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01044fe:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0104501:	8b 45 08             	mov    0x8(%ebp),%eax
c0104504:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104507:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le, page_link);
c010450a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010450d:	83 e8 0c             	sub    $0xc,%eax
c0104510:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(base+n == p) {
c0104513:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104516:	89 d0                	mov    %edx,%eax
c0104518:	c1 e0 02             	shl    $0x2,%eax
c010451b:	01 d0                	add    %edx,%eax
c010451d:	c1 e0 02             	shl    $0x2,%eax
c0104520:	89 c2                	mov    %eax,%edx
c0104522:	8b 45 08             	mov    0x8(%ebp),%eax
c0104525:	01 d0                	add    %edx,%eax
c0104527:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010452a:	75 1e                	jne    c010454a <default_free_pages+0x19a>
        base->property += p->property;
c010452c:	8b 45 08             	mov    0x8(%ebp),%eax
c010452f:	8b 50 08             	mov    0x8(%eax),%edx
c0104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104535:	8b 40 08             	mov    0x8(%eax),%eax
c0104538:	01 c2                	add    %eax,%edx
c010453a:	8b 45 08             	mov    0x8(%ebp),%eax
c010453d:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
c0104540:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104543:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    le = list_prev(&(base->page_link));
c010454a:	8b 45 08             	mov    0x8(%ebp),%eax
c010454d:	83 c0 0c             	add    $0xc,%eax
c0104550:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0104553:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104556:	8b 00                	mov    (%eax),%eax
c0104558:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
c010455b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455e:	83 e8 0c             	sub    $0xc,%eax
c0104561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p==base-1){
c0104564:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c010456b:	74 57                	je     c01045c4 <default_free_pages+0x214>
c010456d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104570:	83 e8 14             	sub    $0x14,%eax
c0104573:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104576:	75 4c                	jne    c01045c4 <default_free_pages+0x214>
        while(le != &free_list) {
c0104578:	eb 41                	jmp    c01045bb <default_free_pages+0x20b>
            //p = le2page(le, page_link);
            if(p->property) {
c010457a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457d:	8b 40 08             	mov    0x8(%eax),%eax
c0104580:	85 c0                	test   %eax,%eax
c0104582:	74 20                	je     c01045a4 <default_free_pages+0x1f4>
                p->property += base->property;
c0104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104587:	8b 50 08             	mov    0x8(%eax),%edx
c010458a:	8b 45 08             	mov    0x8(%ebp),%eax
c010458d:	8b 40 08             	mov    0x8(%eax),%eax
c0104590:	01 c2                	add    %eax,%edx
c0104592:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104595:	89 50 08             	mov    %edx,0x8(%eax)
                base->property = 0;
c0104598:	8b 45 08             	mov    0x8(%ebp),%eax
c010459b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                break;
c01045a2:	eb 20                	jmp    c01045c4 <default_free_pages+0x214>
c01045a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01045aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01045ad:	8b 00                	mov    (%eax),%eax
            }
            le = list_prev(le);
c01045af:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = le2page(le, page_link);
c01045b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b5:	83 e8 0c             	sub    $0xc,%eax
c01045b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
        while(le != &free_list) {
c01045bb:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c01045c2:	75 b6                	jne    c010457a <default_free_pages+0x1ca>
            le = list_prev(le);
            p = le2page(le, page_link);
        }
    }

    nr_free += n;
c01045c4:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c01045ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045cd:	01 d0                	add    %edx,%eax
c01045cf:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    return;
c01045d4:	90                   	nop
    //list_add(&free_list, &(base->page_link));
}
c01045d5:	c9                   	leave  
c01045d6:	c3                   	ret    

c01045d7 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01045d7:	55                   	push   %ebp
c01045d8:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01045da:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c01045df:	5d                   	pop    %ebp
c01045e0:	c3                   	ret    

c01045e1 <basic_check>:

static void
basic_check(void) {
c01045e1:	55                   	push   %ebp
c01045e2:	89 e5                	mov    %esp,%ebp
c01045e4:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01045e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01045fa:	83 ec 0c             	sub    $0xc,%esp
c01045fd:	6a 01                	push   $0x1
c01045ff:	e8 db e5 ff ff       	call   c0102bdf <alloc_pages>
c0104604:	83 c4 10             	add    $0x10,%esp
c0104607:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010460a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010460e:	75 19                	jne    c0104629 <basic_check+0x48>
c0104610:	68 8c 68 10 c0       	push   $0xc010688c
c0104615:	68 3e 68 10 c0       	push   $0xc010683e
c010461a:	68 ad 00 00 00       	push   $0xad
c010461f:	68 53 68 10 c0       	push   $0xc0106853
c0104624:	e8 a9 bd ff ff       	call   c01003d2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104629:	83 ec 0c             	sub    $0xc,%esp
c010462c:	6a 01                	push   $0x1
c010462e:	e8 ac e5 ff ff       	call   c0102bdf <alloc_pages>
c0104633:	83 c4 10             	add    $0x10,%esp
c0104636:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010463d:	75 19                	jne    c0104658 <basic_check+0x77>
c010463f:	68 a8 68 10 c0       	push   $0xc01068a8
c0104644:	68 3e 68 10 c0       	push   $0xc010683e
c0104649:	68 ae 00 00 00       	push   $0xae
c010464e:	68 53 68 10 c0       	push   $0xc0106853
c0104653:	e8 7a bd ff ff       	call   c01003d2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104658:	83 ec 0c             	sub    $0xc,%esp
c010465b:	6a 01                	push   $0x1
c010465d:	e8 7d e5 ff ff       	call   c0102bdf <alloc_pages>
c0104662:	83 c4 10             	add    $0x10,%esp
c0104665:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010466c:	75 19                	jne    c0104687 <basic_check+0xa6>
c010466e:	68 c4 68 10 c0       	push   $0xc01068c4
c0104673:	68 3e 68 10 c0       	push   $0xc010683e
c0104678:	68 af 00 00 00       	push   $0xaf
c010467d:	68 53 68 10 c0       	push   $0xc0106853
c0104682:	e8 4b bd ff ff       	call   c01003d2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104687:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010468a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010468d:	74 10                	je     c010469f <basic_check+0xbe>
c010468f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104692:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104695:	74 08                	je     c010469f <basic_check+0xbe>
c0104697:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010469d:	75 19                	jne    c01046b8 <basic_check+0xd7>
c010469f:	68 e0 68 10 c0       	push   $0xc01068e0
c01046a4:	68 3e 68 10 c0       	push   $0xc010683e
c01046a9:	68 b1 00 00 00       	push   $0xb1
c01046ae:	68 53 68 10 c0       	push   $0xc0106853
c01046b3:	e8 1a bd ff ff       	call   c01003d2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01046b8:	83 ec 0c             	sub    $0xc,%esp
c01046bb:	ff 75 ec             	pushl  -0x14(%ebp)
c01046be:	e8 07 fa ff ff       	call   c01040ca <page_ref>
c01046c3:	83 c4 10             	add    $0x10,%esp
c01046c6:	85 c0                	test   %eax,%eax
c01046c8:	75 24                	jne    c01046ee <basic_check+0x10d>
c01046ca:	83 ec 0c             	sub    $0xc,%esp
c01046cd:	ff 75 f0             	pushl  -0x10(%ebp)
c01046d0:	e8 f5 f9 ff ff       	call   c01040ca <page_ref>
c01046d5:	83 c4 10             	add    $0x10,%esp
c01046d8:	85 c0                	test   %eax,%eax
c01046da:	75 12                	jne    c01046ee <basic_check+0x10d>
c01046dc:	83 ec 0c             	sub    $0xc,%esp
c01046df:	ff 75 f4             	pushl  -0xc(%ebp)
c01046e2:	e8 e3 f9 ff ff       	call   c01040ca <page_ref>
c01046e7:	83 c4 10             	add    $0x10,%esp
c01046ea:	85 c0                	test   %eax,%eax
c01046ec:	74 19                	je     c0104707 <basic_check+0x126>
c01046ee:	68 04 69 10 c0       	push   $0xc0106904
c01046f3:	68 3e 68 10 c0       	push   $0xc010683e
c01046f8:	68 b2 00 00 00       	push   $0xb2
c01046fd:	68 53 68 10 c0       	push   $0xc0106853
c0104702:	e8 cb bc ff ff       	call   c01003d2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104707:	83 ec 0c             	sub    $0xc,%esp
c010470a:	ff 75 ec             	pushl  -0x14(%ebp)
c010470d:	e8 a5 f9 ff ff       	call   c01040b7 <page2pa>
c0104712:	83 c4 10             	add    $0x10,%esp
c0104715:	89 c2                	mov    %eax,%edx
c0104717:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010471c:	c1 e0 0c             	shl    $0xc,%eax
c010471f:	39 c2                	cmp    %eax,%edx
c0104721:	72 19                	jb     c010473c <basic_check+0x15b>
c0104723:	68 40 69 10 c0       	push   $0xc0106940
c0104728:	68 3e 68 10 c0       	push   $0xc010683e
c010472d:	68 b4 00 00 00       	push   $0xb4
c0104732:	68 53 68 10 c0       	push   $0xc0106853
c0104737:	e8 96 bc ff ff       	call   c01003d2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010473c:	83 ec 0c             	sub    $0xc,%esp
c010473f:	ff 75 f0             	pushl  -0x10(%ebp)
c0104742:	e8 70 f9 ff ff       	call   c01040b7 <page2pa>
c0104747:	83 c4 10             	add    $0x10,%esp
c010474a:	89 c2                	mov    %eax,%edx
c010474c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104751:	c1 e0 0c             	shl    $0xc,%eax
c0104754:	39 c2                	cmp    %eax,%edx
c0104756:	72 19                	jb     c0104771 <basic_check+0x190>
c0104758:	68 5d 69 10 c0       	push   $0xc010695d
c010475d:	68 3e 68 10 c0       	push   $0xc010683e
c0104762:	68 b5 00 00 00       	push   $0xb5
c0104767:	68 53 68 10 c0       	push   $0xc0106853
c010476c:	e8 61 bc ff ff       	call   c01003d2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104771:	83 ec 0c             	sub    $0xc,%esp
c0104774:	ff 75 f4             	pushl  -0xc(%ebp)
c0104777:	e8 3b f9 ff ff       	call   c01040b7 <page2pa>
c010477c:	83 c4 10             	add    $0x10,%esp
c010477f:	89 c2                	mov    %eax,%edx
c0104781:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104786:	c1 e0 0c             	shl    $0xc,%eax
c0104789:	39 c2                	cmp    %eax,%edx
c010478b:	72 19                	jb     c01047a6 <basic_check+0x1c5>
c010478d:	68 7a 69 10 c0       	push   $0xc010697a
c0104792:	68 3e 68 10 c0       	push   $0xc010683e
c0104797:	68 b6 00 00 00       	push   $0xb6
c010479c:	68 53 68 10 c0       	push   $0xc0106853
c01047a1:	e8 2c bc ff ff       	call   c01003d2 <__panic>

    list_entry_t free_list_store = free_list;
c01047a6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01047ab:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c01047b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01047b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01047b7:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01047be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047c4:	89 50 04             	mov    %edx,0x4(%eax)
c01047c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ca:	8b 50 04             	mov    0x4(%eax),%edx
c01047cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047d0:	89 10                	mov    %edx,(%eax)
c01047d2:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01047d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047dc:	8b 40 04             	mov    0x4(%eax),%eax
c01047df:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01047e2:	0f 94 c0             	sete   %al
c01047e5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01047e8:	85 c0                	test   %eax,%eax
c01047ea:	75 19                	jne    c0104805 <basic_check+0x224>
c01047ec:	68 97 69 10 c0       	push   $0xc0106997
c01047f1:	68 3e 68 10 c0       	push   $0xc010683e
c01047f6:	68 ba 00 00 00       	push   $0xba
c01047fb:	68 53 68 10 c0       	push   $0xc0106853
c0104800:	e8 cd bb ff ff       	call   c01003d2 <__panic>

    unsigned int nr_free_store = nr_free;
c0104805:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010480a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010480d:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104814:	00 00 00 

    assert(alloc_page() == NULL);
c0104817:	83 ec 0c             	sub    $0xc,%esp
c010481a:	6a 01                	push   $0x1
c010481c:	e8 be e3 ff ff       	call   c0102bdf <alloc_pages>
c0104821:	83 c4 10             	add    $0x10,%esp
c0104824:	85 c0                	test   %eax,%eax
c0104826:	74 19                	je     c0104841 <basic_check+0x260>
c0104828:	68 ae 69 10 c0       	push   $0xc01069ae
c010482d:	68 3e 68 10 c0       	push   $0xc010683e
c0104832:	68 bf 00 00 00       	push   $0xbf
c0104837:	68 53 68 10 c0       	push   $0xc0106853
c010483c:	e8 91 bb ff ff       	call   c01003d2 <__panic>

    free_page(p0);
c0104841:	83 ec 08             	sub    $0x8,%esp
c0104844:	6a 01                	push   $0x1
c0104846:	ff 75 ec             	pushl  -0x14(%ebp)
c0104849:	e8 cf e3 ff ff       	call   c0102c1d <free_pages>
c010484e:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104851:	83 ec 08             	sub    $0x8,%esp
c0104854:	6a 01                	push   $0x1
c0104856:	ff 75 f0             	pushl  -0x10(%ebp)
c0104859:	e8 bf e3 ff ff       	call   c0102c1d <free_pages>
c010485e:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104861:	83 ec 08             	sub    $0x8,%esp
c0104864:	6a 01                	push   $0x1
c0104866:	ff 75 f4             	pushl  -0xc(%ebp)
c0104869:	e8 af e3 ff ff       	call   c0102c1d <free_pages>
c010486e:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c0104871:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104876:	83 f8 03             	cmp    $0x3,%eax
c0104879:	74 19                	je     c0104894 <basic_check+0x2b3>
c010487b:	68 c3 69 10 c0       	push   $0xc01069c3
c0104880:	68 3e 68 10 c0       	push   $0xc010683e
c0104885:	68 c4 00 00 00       	push   $0xc4
c010488a:	68 53 68 10 c0       	push   $0xc0106853
c010488f:	e8 3e bb ff ff       	call   c01003d2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104894:	83 ec 0c             	sub    $0xc,%esp
c0104897:	6a 01                	push   $0x1
c0104899:	e8 41 e3 ff ff       	call   c0102bdf <alloc_pages>
c010489e:	83 c4 10             	add    $0x10,%esp
c01048a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01048a8:	75 19                	jne    c01048c3 <basic_check+0x2e2>
c01048aa:	68 8c 68 10 c0       	push   $0xc010688c
c01048af:	68 3e 68 10 c0       	push   $0xc010683e
c01048b4:	68 c6 00 00 00       	push   $0xc6
c01048b9:	68 53 68 10 c0       	push   $0xc0106853
c01048be:	e8 0f bb ff ff       	call   c01003d2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01048c3:	83 ec 0c             	sub    $0xc,%esp
c01048c6:	6a 01                	push   $0x1
c01048c8:	e8 12 e3 ff ff       	call   c0102bdf <alloc_pages>
c01048cd:	83 c4 10             	add    $0x10,%esp
c01048d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048d7:	75 19                	jne    c01048f2 <basic_check+0x311>
c01048d9:	68 a8 68 10 c0       	push   $0xc01068a8
c01048de:	68 3e 68 10 c0       	push   $0xc010683e
c01048e3:	68 c7 00 00 00       	push   $0xc7
c01048e8:	68 53 68 10 c0       	push   $0xc0106853
c01048ed:	e8 e0 ba ff ff       	call   c01003d2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048f2:	83 ec 0c             	sub    $0xc,%esp
c01048f5:	6a 01                	push   $0x1
c01048f7:	e8 e3 e2 ff ff       	call   c0102bdf <alloc_pages>
c01048fc:	83 c4 10             	add    $0x10,%esp
c01048ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104902:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104906:	75 19                	jne    c0104921 <basic_check+0x340>
c0104908:	68 c4 68 10 c0       	push   $0xc01068c4
c010490d:	68 3e 68 10 c0       	push   $0xc010683e
c0104912:	68 c8 00 00 00       	push   $0xc8
c0104917:	68 53 68 10 c0       	push   $0xc0106853
c010491c:	e8 b1 ba ff ff       	call   c01003d2 <__panic>

    assert(alloc_page() == NULL);
c0104921:	83 ec 0c             	sub    $0xc,%esp
c0104924:	6a 01                	push   $0x1
c0104926:	e8 b4 e2 ff ff       	call   c0102bdf <alloc_pages>
c010492b:	83 c4 10             	add    $0x10,%esp
c010492e:	85 c0                	test   %eax,%eax
c0104930:	74 19                	je     c010494b <basic_check+0x36a>
c0104932:	68 ae 69 10 c0       	push   $0xc01069ae
c0104937:	68 3e 68 10 c0       	push   $0xc010683e
c010493c:	68 ca 00 00 00       	push   $0xca
c0104941:	68 53 68 10 c0       	push   $0xc0106853
c0104946:	e8 87 ba ff ff       	call   c01003d2 <__panic>

    free_page(p0);
c010494b:	83 ec 08             	sub    $0x8,%esp
c010494e:	6a 01                	push   $0x1
c0104950:	ff 75 ec             	pushl  -0x14(%ebp)
c0104953:	e8 c5 e2 ff ff       	call   c0102c1d <free_pages>
c0104958:	83 c4 10             	add    $0x10,%esp
c010495b:	c7 45 e8 5c 89 11 c0 	movl   $0xc011895c,-0x18(%ebp)
c0104962:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104965:	8b 40 04             	mov    0x4(%eax),%eax
c0104968:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010496b:	0f 94 c0             	sete   %al
c010496e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104971:	85 c0                	test   %eax,%eax
c0104973:	74 19                	je     c010498e <basic_check+0x3ad>
c0104975:	68 d0 69 10 c0       	push   $0xc01069d0
c010497a:	68 3e 68 10 c0       	push   $0xc010683e
c010497f:	68 cd 00 00 00       	push   $0xcd
c0104984:	68 53 68 10 c0       	push   $0xc0106853
c0104989:	e8 44 ba ff ff       	call   c01003d2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010498e:	83 ec 0c             	sub    $0xc,%esp
c0104991:	6a 01                	push   $0x1
c0104993:	e8 47 e2 ff ff       	call   c0102bdf <alloc_pages>
c0104998:	83 c4 10             	add    $0x10,%esp
c010499b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010499e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01049a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01049a4:	74 19                	je     c01049bf <basic_check+0x3de>
c01049a6:	68 e8 69 10 c0       	push   $0xc01069e8
c01049ab:	68 3e 68 10 c0       	push   $0xc010683e
c01049b0:	68 d0 00 00 00       	push   $0xd0
c01049b5:	68 53 68 10 c0       	push   $0xc0106853
c01049ba:	e8 13 ba ff ff       	call   c01003d2 <__panic>
    assert(alloc_page() == NULL);
c01049bf:	83 ec 0c             	sub    $0xc,%esp
c01049c2:	6a 01                	push   $0x1
c01049c4:	e8 16 e2 ff ff       	call   c0102bdf <alloc_pages>
c01049c9:	83 c4 10             	add    $0x10,%esp
c01049cc:	85 c0                	test   %eax,%eax
c01049ce:	74 19                	je     c01049e9 <basic_check+0x408>
c01049d0:	68 ae 69 10 c0       	push   $0xc01069ae
c01049d5:	68 3e 68 10 c0       	push   $0xc010683e
c01049da:	68 d1 00 00 00       	push   $0xd1
c01049df:	68 53 68 10 c0       	push   $0xc0106853
c01049e4:	e8 e9 b9 ff ff       	call   c01003d2 <__panic>

    assert(nr_free == 0);
c01049e9:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01049ee:	85 c0                	test   %eax,%eax
c01049f0:	74 19                	je     c0104a0b <basic_check+0x42a>
c01049f2:	68 01 6a 10 c0       	push   $0xc0106a01
c01049f7:	68 3e 68 10 c0       	push   $0xc010683e
c01049fc:	68 d3 00 00 00       	push   $0xd3
c0104a01:	68 53 68 10 c0       	push   $0xc0106853
c0104a06:	e8 c7 b9 ff ff       	call   c01003d2 <__panic>
    free_list = free_list_store;
c0104a0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a11:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104a16:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c0104a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a1f:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_page(p);
c0104a24:	83 ec 08             	sub    $0x8,%esp
c0104a27:	6a 01                	push   $0x1
c0104a29:	ff 75 dc             	pushl  -0x24(%ebp)
c0104a2c:	e8 ec e1 ff ff       	call   c0102c1d <free_pages>
c0104a31:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104a34:	83 ec 08             	sub    $0x8,%esp
c0104a37:	6a 01                	push   $0x1
c0104a39:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a3c:	e8 dc e1 ff ff       	call   c0102c1d <free_pages>
c0104a41:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104a44:	83 ec 08             	sub    $0x8,%esp
c0104a47:	6a 01                	push   $0x1
c0104a49:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a4c:	e8 cc e1 ff ff       	call   c0102c1d <free_pages>
c0104a51:	83 c4 10             	add    $0x10,%esp
}
c0104a54:	90                   	nop
c0104a55:	c9                   	leave  
c0104a56:	c3                   	ret    

c0104a57 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a57:	55                   	push   %ebp
c0104a58:	89 e5                	mov    %esp,%ebp
c0104a5a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a6e:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a75:	eb 60                	jmp    c0104ad7 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a7a:	83 e8 0c             	sub    $0xc,%eax
c0104a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a83:	83 c0 04             	add    $0x4,%eax
c0104a86:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104a8d:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a90:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104a93:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a96:	0f a3 10             	bt     %edx,(%eax)
c0104a99:	19 c0                	sbb    %eax,%eax
c0104a9b:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104a9e:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104aa2:	0f 95 c0             	setne  %al
c0104aa5:	0f b6 c0             	movzbl %al,%eax
c0104aa8:	85 c0                	test   %eax,%eax
c0104aaa:	75 19                	jne    c0104ac5 <default_check+0x6e>
c0104aac:	68 0e 6a 10 c0       	push   $0xc0106a0e
c0104ab1:	68 3e 68 10 c0       	push   $0xc010683e
c0104ab6:	68 e4 00 00 00       	push   $0xe4
c0104abb:	68 53 68 10 c0       	push   $0xc0106853
c0104ac0:	e8 0d b9 ff ff       	call   c01003d2 <__panic>
        count ++, total += p->property;
c0104ac5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104acc:	8b 50 08             	mov    0x8(%eax),%edx
c0104acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad2:	01 d0                	add    %edx,%eax
c0104ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ada:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104add:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ae0:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104ae3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ae6:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104aed:	75 88                	jne    c0104a77 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104aef:	e8 5e e1 ff ff       	call   c0102c52 <nr_free_pages>
c0104af4:	89 c2                	mov    %eax,%edx
c0104af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af9:	39 c2                	cmp    %eax,%edx
c0104afb:	74 19                	je     c0104b16 <default_check+0xbf>
c0104afd:	68 1e 6a 10 c0       	push   $0xc0106a1e
c0104b02:	68 3e 68 10 c0       	push   $0xc010683e
c0104b07:	68 e7 00 00 00       	push   $0xe7
c0104b0c:	68 53 68 10 c0       	push   $0xc0106853
c0104b11:	e8 bc b8 ff ff       	call   c01003d2 <__panic>

    basic_check();
c0104b16:	e8 c6 fa ff ff       	call   c01045e1 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104b1b:	83 ec 0c             	sub    $0xc,%esp
c0104b1e:	6a 05                	push   $0x5
c0104b20:	e8 ba e0 ff ff       	call   c0102bdf <alloc_pages>
c0104b25:	83 c4 10             	add    $0x10,%esp
c0104b28:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104b2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104b2f:	75 19                	jne    c0104b4a <default_check+0xf3>
c0104b31:	68 37 6a 10 c0       	push   $0xc0106a37
c0104b36:	68 3e 68 10 c0       	push   $0xc010683e
c0104b3b:	68 ec 00 00 00       	push   $0xec
c0104b40:	68 53 68 10 c0       	push   $0xc0106853
c0104b45:	e8 88 b8 ff ff       	call   c01003d2 <__panic>
    assert(!PageProperty(p0));
c0104b4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b4d:	83 c0 04             	add    $0x4,%eax
c0104b50:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104b57:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b5a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b60:	0f a3 10             	bt     %edx,(%eax)
c0104b63:	19 c0                	sbb    %eax,%eax
c0104b65:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104b68:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104b6c:	0f 95 c0             	setne  %al
c0104b6f:	0f b6 c0             	movzbl %al,%eax
c0104b72:	85 c0                	test   %eax,%eax
c0104b74:	74 19                	je     c0104b8f <default_check+0x138>
c0104b76:	68 42 6a 10 c0       	push   $0xc0106a42
c0104b7b:	68 3e 68 10 c0       	push   $0xc010683e
c0104b80:	68 ed 00 00 00       	push   $0xed
c0104b85:	68 53 68 10 c0       	push   $0xc0106853
c0104b8a:	e8 43 b8 ff ff       	call   c01003d2 <__panic>

    list_entry_t free_list_store = free_list;
c0104b8f:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104b94:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104b9a:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104b9d:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104ba0:	c7 45 d0 5c 89 11 c0 	movl   $0xc011895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104ba7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104baa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104bad:	89 50 04             	mov    %edx,0x4(%eax)
c0104bb0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bb3:	8b 50 04             	mov    0x4(%eax),%edx
c0104bb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bb9:	89 10                	mov    %edx,(%eax)
c0104bbb:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104bc5:	8b 40 04             	mov    0x4(%eax),%eax
c0104bc8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104bcb:	0f 94 c0             	sete   %al
c0104bce:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104bd1:	85 c0                	test   %eax,%eax
c0104bd3:	75 19                	jne    c0104bee <default_check+0x197>
c0104bd5:	68 97 69 10 c0       	push   $0xc0106997
c0104bda:	68 3e 68 10 c0       	push   $0xc010683e
c0104bdf:	68 f1 00 00 00       	push   $0xf1
c0104be4:	68 53 68 10 c0       	push   $0xc0106853
c0104be9:	e8 e4 b7 ff ff       	call   c01003d2 <__panic>
    assert(alloc_page() == NULL);
c0104bee:	83 ec 0c             	sub    $0xc,%esp
c0104bf1:	6a 01                	push   $0x1
c0104bf3:	e8 e7 df ff ff       	call   c0102bdf <alloc_pages>
c0104bf8:	83 c4 10             	add    $0x10,%esp
c0104bfb:	85 c0                	test   %eax,%eax
c0104bfd:	74 19                	je     c0104c18 <default_check+0x1c1>
c0104bff:	68 ae 69 10 c0       	push   $0xc01069ae
c0104c04:	68 3e 68 10 c0       	push   $0xc010683e
c0104c09:	68 f2 00 00 00       	push   $0xf2
c0104c0e:	68 53 68 10 c0       	push   $0xc0106853
c0104c13:	e8 ba b7 ff ff       	call   c01003d2 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c18:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104c1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104c20:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104c27:	00 00 00 

    free_pages(p0 + 2, 3);
c0104c2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c2d:	83 c0 28             	add    $0x28,%eax
c0104c30:	83 ec 08             	sub    $0x8,%esp
c0104c33:	6a 03                	push   $0x3
c0104c35:	50                   	push   %eax
c0104c36:	e8 e2 df ff ff       	call   c0102c1d <free_pages>
c0104c3b:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104c3e:	83 ec 0c             	sub    $0xc,%esp
c0104c41:	6a 04                	push   $0x4
c0104c43:	e8 97 df ff ff       	call   c0102bdf <alloc_pages>
c0104c48:	83 c4 10             	add    $0x10,%esp
c0104c4b:	85 c0                	test   %eax,%eax
c0104c4d:	74 19                	je     c0104c68 <default_check+0x211>
c0104c4f:	68 54 6a 10 c0       	push   $0xc0106a54
c0104c54:	68 3e 68 10 c0       	push   $0xc010683e
c0104c59:	68 f8 00 00 00       	push   $0xf8
c0104c5e:	68 53 68 10 c0       	push   $0xc0106853
c0104c63:	e8 6a b7 ff ff       	call   c01003d2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104c68:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c6b:	83 c0 28             	add    $0x28,%eax
c0104c6e:	83 c0 04             	add    $0x4,%eax
c0104c71:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104c78:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c7b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c7e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c81:	0f a3 10             	bt     %edx,(%eax)
c0104c84:	19 c0                	sbb    %eax,%eax
c0104c86:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104c89:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104c8d:	0f 95 c0             	setne  %al
c0104c90:	0f b6 c0             	movzbl %al,%eax
c0104c93:	85 c0                	test   %eax,%eax
c0104c95:	74 0e                	je     c0104ca5 <default_check+0x24e>
c0104c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c9a:	83 c0 28             	add    $0x28,%eax
c0104c9d:	8b 40 08             	mov    0x8(%eax),%eax
c0104ca0:	83 f8 03             	cmp    $0x3,%eax
c0104ca3:	74 19                	je     c0104cbe <default_check+0x267>
c0104ca5:	68 6c 6a 10 c0       	push   $0xc0106a6c
c0104caa:	68 3e 68 10 c0       	push   $0xc010683e
c0104caf:	68 f9 00 00 00       	push   $0xf9
c0104cb4:	68 53 68 10 c0       	push   $0xc0106853
c0104cb9:	e8 14 b7 ff ff       	call   c01003d2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104cbe:	83 ec 0c             	sub    $0xc,%esp
c0104cc1:	6a 03                	push   $0x3
c0104cc3:	e8 17 df ff ff       	call   c0102bdf <alloc_pages>
c0104cc8:	83 c4 10             	add    $0x10,%esp
c0104ccb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104cce:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104cd2:	75 19                	jne    c0104ced <default_check+0x296>
c0104cd4:	68 98 6a 10 c0       	push   $0xc0106a98
c0104cd9:	68 3e 68 10 c0       	push   $0xc010683e
c0104cde:	68 fa 00 00 00       	push   $0xfa
c0104ce3:	68 53 68 10 c0       	push   $0xc0106853
c0104ce8:	e8 e5 b6 ff ff       	call   c01003d2 <__panic>
    assert(alloc_page() == NULL);
c0104ced:	83 ec 0c             	sub    $0xc,%esp
c0104cf0:	6a 01                	push   $0x1
c0104cf2:	e8 e8 de ff ff       	call   c0102bdf <alloc_pages>
c0104cf7:	83 c4 10             	add    $0x10,%esp
c0104cfa:	85 c0                	test   %eax,%eax
c0104cfc:	74 19                	je     c0104d17 <default_check+0x2c0>
c0104cfe:	68 ae 69 10 c0       	push   $0xc01069ae
c0104d03:	68 3e 68 10 c0       	push   $0xc010683e
c0104d08:	68 fb 00 00 00       	push   $0xfb
c0104d0d:	68 53 68 10 c0       	push   $0xc0106853
c0104d12:	e8 bb b6 ff ff       	call   c01003d2 <__panic>
    assert(p0 + 2 == p1);
c0104d17:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d1a:	83 c0 28             	add    $0x28,%eax
c0104d1d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104d20:	74 19                	je     c0104d3b <default_check+0x2e4>
c0104d22:	68 b6 6a 10 c0       	push   $0xc0106ab6
c0104d27:	68 3e 68 10 c0       	push   $0xc010683e
c0104d2c:	68 fc 00 00 00       	push   $0xfc
c0104d31:	68 53 68 10 c0       	push   $0xc0106853
c0104d36:	e8 97 b6 ff ff       	call   c01003d2 <__panic>

    p2 = p0 + 1;
c0104d3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d3e:	83 c0 14             	add    $0x14,%eax
c0104d41:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104d44:	83 ec 08             	sub    $0x8,%esp
c0104d47:	6a 01                	push   $0x1
c0104d49:	ff 75 dc             	pushl  -0x24(%ebp)
c0104d4c:	e8 cc de ff ff       	call   c0102c1d <free_pages>
c0104d51:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104d54:	83 ec 08             	sub    $0x8,%esp
c0104d57:	6a 03                	push   $0x3
c0104d59:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104d5c:	e8 bc de ff ff       	call   c0102c1d <free_pages>
c0104d61:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104d64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d67:	83 c0 04             	add    $0x4,%eax
c0104d6a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104d71:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d74:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104d77:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104d7a:	0f a3 10             	bt     %edx,(%eax)
c0104d7d:	19 c0                	sbb    %eax,%eax
c0104d7f:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104d82:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104d86:	0f 95 c0             	setne  %al
c0104d89:	0f b6 c0             	movzbl %al,%eax
c0104d8c:	85 c0                	test   %eax,%eax
c0104d8e:	74 0b                	je     c0104d9b <default_check+0x344>
c0104d90:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d93:	8b 40 08             	mov    0x8(%eax),%eax
c0104d96:	83 f8 01             	cmp    $0x1,%eax
c0104d99:	74 19                	je     c0104db4 <default_check+0x35d>
c0104d9b:	68 c4 6a 10 c0       	push   $0xc0106ac4
c0104da0:	68 3e 68 10 c0       	push   $0xc010683e
c0104da5:	68 01 01 00 00       	push   $0x101
c0104daa:	68 53 68 10 c0       	push   $0xc0106853
c0104daf:	e8 1e b6 ff ff       	call   c01003d2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104db4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104db7:	83 c0 04             	add    $0x4,%eax
c0104dba:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104dc1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dc4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104dc7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104dca:	0f a3 10             	bt     %edx,(%eax)
c0104dcd:	19 c0                	sbb    %eax,%eax
c0104dcf:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104dd2:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104dd6:	0f 95 c0             	setne  %al
c0104dd9:	0f b6 c0             	movzbl %al,%eax
c0104ddc:	85 c0                	test   %eax,%eax
c0104dde:	74 0b                	je     c0104deb <default_check+0x394>
c0104de0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104de3:	8b 40 08             	mov    0x8(%eax),%eax
c0104de6:	83 f8 03             	cmp    $0x3,%eax
c0104de9:	74 19                	je     c0104e04 <default_check+0x3ad>
c0104deb:	68 ec 6a 10 c0       	push   $0xc0106aec
c0104df0:	68 3e 68 10 c0       	push   $0xc010683e
c0104df5:	68 02 01 00 00       	push   $0x102
c0104dfa:	68 53 68 10 c0       	push   $0xc0106853
c0104dff:	e8 ce b5 ff ff       	call   c01003d2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104e04:	83 ec 0c             	sub    $0xc,%esp
c0104e07:	6a 01                	push   $0x1
c0104e09:	e8 d1 dd ff ff       	call   c0102bdf <alloc_pages>
c0104e0e:	83 c4 10             	add    $0x10,%esp
c0104e11:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e14:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104e17:	83 e8 14             	sub    $0x14,%eax
c0104e1a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e1d:	74 19                	je     c0104e38 <default_check+0x3e1>
c0104e1f:	68 12 6b 10 c0       	push   $0xc0106b12
c0104e24:	68 3e 68 10 c0       	push   $0xc010683e
c0104e29:	68 04 01 00 00       	push   $0x104
c0104e2e:	68 53 68 10 c0       	push   $0xc0106853
c0104e33:	e8 9a b5 ff ff       	call   c01003d2 <__panic>
    free_page(p0);
c0104e38:	83 ec 08             	sub    $0x8,%esp
c0104e3b:	6a 01                	push   $0x1
c0104e3d:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e40:	e8 d8 dd ff ff       	call   c0102c1d <free_pages>
c0104e45:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104e48:	83 ec 0c             	sub    $0xc,%esp
c0104e4b:	6a 02                	push   $0x2
c0104e4d:	e8 8d dd ff ff       	call   c0102bdf <alloc_pages>
c0104e52:	83 c4 10             	add    $0x10,%esp
c0104e55:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e58:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104e5b:	83 c0 14             	add    $0x14,%eax
c0104e5e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e61:	74 19                	je     c0104e7c <default_check+0x425>
c0104e63:	68 30 6b 10 c0       	push   $0xc0106b30
c0104e68:	68 3e 68 10 c0       	push   $0xc010683e
c0104e6d:	68 06 01 00 00       	push   $0x106
c0104e72:	68 53 68 10 c0       	push   $0xc0106853
c0104e77:	e8 56 b5 ff ff       	call   c01003d2 <__panic>

    free_pages(p0, 2);
c0104e7c:	83 ec 08             	sub    $0x8,%esp
c0104e7f:	6a 02                	push   $0x2
c0104e81:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e84:	e8 94 dd ff ff       	call   c0102c1d <free_pages>
c0104e89:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104e8c:	83 ec 08             	sub    $0x8,%esp
c0104e8f:	6a 01                	push   $0x1
c0104e91:	ff 75 c0             	pushl  -0x40(%ebp)
c0104e94:	e8 84 dd ff ff       	call   c0102c1d <free_pages>
c0104e99:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0104e9c:	83 ec 0c             	sub    $0xc,%esp
c0104e9f:	6a 05                	push   $0x5
c0104ea1:	e8 39 dd ff ff       	call   c0102bdf <alloc_pages>
c0104ea6:	83 c4 10             	add    $0x10,%esp
c0104ea9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104eac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104eb0:	75 19                	jne    c0104ecb <default_check+0x474>
c0104eb2:	68 50 6b 10 c0       	push   $0xc0106b50
c0104eb7:	68 3e 68 10 c0       	push   $0xc010683e
c0104ebc:	68 0b 01 00 00       	push   $0x10b
c0104ec1:	68 53 68 10 c0       	push   $0xc0106853
c0104ec6:	e8 07 b5 ff ff       	call   c01003d2 <__panic>
    assert(alloc_page() == NULL);
c0104ecb:	83 ec 0c             	sub    $0xc,%esp
c0104ece:	6a 01                	push   $0x1
c0104ed0:	e8 0a dd ff ff       	call   c0102bdf <alloc_pages>
c0104ed5:	83 c4 10             	add    $0x10,%esp
c0104ed8:	85 c0                	test   %eax,%eax
c0104eda:	74 19                	je     c0104ef5 <default_check+0x49e>
c0104edc:	68 ae 69 10 c0       	push   $0xc01069ae
c0104ee1:	68 3e 68 10 c0       	push   $0xc010683e
c0104ee6:	68 0c 01 00 00       	push   $0x10c
c0104eeb:	68 53 68 10 c0       	push   $0xc0106853
c0104ef0:	e8 dd b4 ff ff       	call   c01003d2 <__panic>

    assert(nr_free == 0);
c0104ef5:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104efa:	85 c0                	test   %eax,%eax
c0104efc:	74 19                	je     c0104f17 <default_check+0x4c0>
c0104efe:	68 01 6a 10 c0       	push   $0xc0106a01
c0104f03:	68 3e 68 10 c0       	push   $0xc010683e
c0104f08:	68 0e 01 00 00       	push   $0x10e
c0104f0d:	68 53 68 10 c0       	push   $0xc0106853
c0104f12:	e8 bb b4 ff ff       	call   c01003d2 <__panic>
    nr_free = nr_free_store;
c0104f17:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104f1a:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c0104f1f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104f22:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f25:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104f2a:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c0104f30:	83 ec 08             	sub    $0x8,%esp
c0104f33:	6a 05                	push   $0x5
c0104f35:	ff 75 dc             	pushl  -0x24(%ebp)
c0104f38:	e8 e0 dc ff ff       	call   c0102c1d <free_pages>
c0104f3d:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0104f40:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f47:	eb 1d                	jmp    c0104f66 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0104f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f4c:	83 e8 0c             	sub    $0xc,%eax
c0104f4f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0104f52:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104f56:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f59:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f5c:	8b 40 08             	mov    0x8(%eax),%eax
c0104f5f:	29 c2                	sub    %eax,%edx
c0104f61:	89 d0                	mov    %edx,%eax
c0104f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f69:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104f6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f6f:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f75:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104f7c:	75 cb                	jne    c0104f49 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f82:	74 19                	je     c0104f9d <default_check+0x546>
c0104f84:	68 6e 6b 10 c0       	push   $0xc0106b6e
c0104f89:	68 3e 68 10 c0       	push   $0xc010683e
c0104f8e:	68 19 01 00 00       	push   $0x119
c0104f93:	68 53 68 10 c0       	push   $0xc0106853
c0104f98:	e8 35 b4 ff ff       	call   c01003d2 <__panic>
    assert(total == 0);
c0104f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104fa1:	74 19                	je     c0104fbc <default_check+0x565>
c0104fa3:	68 79 6b 10 c0       	push   $0xc0106b79
c0104fa8:	68 3e 68 10 c0       	push   $0xc010683e
c0104fad:	68 1a 01 00 00       	push   $0x11a
c0104fb2:	68 53 68 10 c0       	push   $0xc0106853
c0104fb7:	e8 16 b4 ff ff       	call   c01003d2 <__panic>
}
c0104fbc:	90                   	nop
c0104fbd:	c9                   	leave  
c0104fbe:	c3                   	ret    

c0104fbf <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0104fbf:	55                   	push   %ebp
c0104fc0:	89 e5                	mov    %esp,%ebp
c0104fc2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104fcc:	eb 04                	jmp    c0104fd2 <strlen+0x13>
        cnt ++;
c0104fce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0104fd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fd5:	8d 50 01             	lea    0x1(%eax),%edx
c0104fd8:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fdb:	0f b6 00             	movzbl (%eax),%eax
c0104fde:	84 c0                	test   %al,%al
c0104fe0:	75 ec                	jne    c0104fce <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0104fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104fe5:	c9                   	leave  
c0104fe6:	c3                   	ret    

c0104fe7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0104fe7:	55                   	push   %ebp
c0104fe8:	89 e5                	mov    %esp,%ebp
c0104fea:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0104ff4:	eb 04                	jmp    c0104ffa <strnlen+0x13>
        cnt ++;
c0104ff6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0104ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104ffd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105000:	73 10                	jae    c0105012 <strnlen+0x2b>
c0105002:	8b 45 08             	mov    0x8(%ebp),%eax
c0105005:	8d 50 01             	lea    0x1(%eax),%edx
c0105008:	89 55 08             	mov    %edx,0x8(%ebp)
c010500b:	0f b6 00             	movzbl (%eax),%eax
c010500e:	84 c0                	test   %al,%al
c0105010:	75 e4                	jne    c0104ff6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105012:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105015:	c9                   	leave  
c0105016:	c3                   	ret    

c0105017 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105017:	55                   	push   %ebp
c0105018:	89 e5                	mov    %esp,%ebp
c010501a:	57                   	push   %edi
c010501b:	56                   	push   %esi
c010501c:	83 ec 20             	sub    $0x20,%esp
c010501f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105022:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105025:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105028:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010502b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010502e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105031:	89 d1                	mov    %edx,%ecx
c0105033:	89 c2                	mov    %eax,%edx
c0105035:	89 ce                	mov    %ecx,%esi
c0105037:	89 d7                	mov    %edx,%edi
c0105039:	ac                   	lods   %ds:(%esi),%al
c010503a:	aa                   	stos   %al,%es:(%edi)
c010503b:	84 c0                	test   %al,%al
c010503d:	75 fa                	jne    c0105039 <strcpy+0x22>
c010503f:	89 fa                	mov    %edi,%edx
c0105041:	89 f1                	mov    %esi,%ecx
c0105043:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105046:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010504c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010504f:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105050:	83 c4 20             	add    $0x20,%esp
c0105053:	5e                   	pop    %esi
c0105054:	5f                   	pop    %edi
c0105055:	5d                   	pop    %ebp
c0105056:	c3                   	ret    

c0105057 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105057:	55                   	push   %ebp
c0105058:	89 e5                	mov    %esp,%ebp
c010505a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010505d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105060:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105063:	eb 21                	jmp    c0105086 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105065:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105068:	0f b6 10             	movzbl (%eax),%edx
c010506b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010506e:	88 10                	mov    %dl,(%eax)
c0105070:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105073:	0f b6 00             	movzbl (%eax),%eax
c0105076:	84 c0                	test   %al,%al
c0105078:	74 04                	je     c010507e <strncpy+0x27>
            src ++;
c010507a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010507e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105082:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105086:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010508a:	75 d9                	jne    c0105065 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010508c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010508f:	c9                   	leave  
c0105090:	c3                   	ret    

c0105091 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105091:	55                   	push   %ebp
c0105092:	89 e5                	mov    %esp,%ebp
c0105094:	57                   	push   %edi
c0105095:	56                   	push   %esi
c0105096:	83 ec 20             	sub    $0x20,%esp
c0105099:	8b 45 08             	mov    0x8(%ebp),%eax
c010509c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050ab:	89 d1                	mov    %edx,%ecx
c01050ad:	89 c2                	mov    %eax,%edx
c01050af:	89 ce                	mov    %ecx,%esi
c01050b1:	89 d7                	mov    %edx,%edi
c01050b3:	ac                   	lods   %ds:(%esi),%al
c01050b4:	ae                   	scas   %es:(%edi),%al
c01050b5:	75 08                	jne    c01050bf <strcmp+0x2e>
c01050b7:	84 c0                	test   %al,%al
c01050b9:	75 f8                	jne    c01050b3 <strcmp+0x22>
c01050bb:	31 c0                	xor    %eax,%eax
c01050bd:	eb 04                	jmp    c01050c3 <strcmp+0x32>
c01050bf:	19 c0                	sbb    %eax,%eax
c01050c1:	0c 01                	or     $0x1,%al
c01050c3:	89 fa                	mov    %edi,%edx
c01050c5:	89 f1                	mov    %esi,%ecx
c01050c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050ca:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01050cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01050d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01050d3:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01050d4:	83 c4 20             	add    $0x20,%esp
c01050d7:	5e                   	pop    %esi
c01050d8:	5f                   	pop    %edi
c01050d9:	5d                   	pop    %ebp
c01050da:	c3                   	ret    

c01050db <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01050db:	55                   	push   %ebp
c01050dc:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050de:	eb 0c                	jmp    c01050ec <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01050e0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01050e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01050e8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050f0:	74 1a                	je     c010510c <strncmp+0x31>
c01050f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f5:	0f b6 00             	movzbl (%eax),%eax
c01050f8:	84 c0                	test   %al,%al
c01050fa:	74 10                	je     c010510c <strncmp+0x31>
c01050fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ff:	0f b6 10             	movzbl (%eax),%edx
c0105102:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105105:	0f b6 00             	movzbl (%eax),%eax
c0105108:	38 c2                	cmp    %al,%dl
c010510a:	74 d4                	je     c01050e0 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010510c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105110:	74 18                	je     c010512a <strncmp+0x4f>
c0105112:	8b 45 08             	mov    0x8(%ebp),%eax
c0105115:	0f b6 00             	movzbl (%eax),%eax
c0105118:	0f b6 d0             	movzbl %al,%edx
c010511b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010511e:	0f b6 00             	movzbl (%eax),%eax
c0105121:	0f b6 c0             	movzbl %al,%eax
c0105124:	29 c2                	sub    %eax,%edx
c0105126:	89 d0                	mov    %edx,%eax
c0105128:	eb 05                	jmp    c010512f <strncmp+0x54>
c010512a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010512f:	5d                   	pop    %ebp
c0105130:	c3                   	ret    

c0105131 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105131:	55                   	push   %ebp
c0105132:	89 e5                	mov    %esp,%ebp
c0105134:	83 ec 04             	sub    $0x4,%esp
c0105137:	8b 45 0c             	mov    0xc(%ebp),%eax
c010513a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010513d:	eb 14                	jmp    c0105153 <strchr+0x22>
        if (*s == c) {
c010513f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105142:	0f b6 00             	movzbl (%eax),%eax
c0105145:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105148:	75 05                	jne    c010514f <strchr+0x1e>
            return (char *)s;
c010514a:	8b 45 08             	mov    0x8(%ebp),%eax
c010514d:	eb 13                	jmp    c0105162 <strchr+0x31>
        }
        s ++;
c010514f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105153:	8b 45 08             	mov    0x8(%ebp),%eax
c0105156:	0f b6 00             	movzbl (%eax),%eax
c0105159:	84 c0                	test   %al,%al
c010515b:	75 e2                	jne    c010513f <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010515d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105162:	c9                   	leave  
c0105163:	c3                   	ret    

c0105164 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105164:	55                   	push   %ebp
c0105165:	89 e5                	mov    %esp,%ebp
c0105167:	83 ec 04             	sub    $0x4,%esp
c010516a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010516d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105170:	eb 0f                	jmp    c0105181 <strfind+0x1d>
        if (*s == c) {
c0105172:	8b 45 08             	mov    0x8(%ebp),%eax
c0105175:	0f b6 00             	movzbl (%eax),%eax
c0105178:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010517b:	74 10                	je     c010518d <strfind+0x29>
            break;
        }
        s ++;
c010517d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105181:	8b 45 08             	mov    0x8(%ebp),%eax
c0105184:	0f b6 00             	movzbl (%eax),%eax
c0105187:	84 c0                	test   %al,%al
c0105189:	75 e7                	jne    c0105172 <strfind+0xe>
c010518b:	eb 01                	jmp    c010518e <strfind+0x2a>
        if (*s == c) {
            break;
c010518d:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c010518e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105191:	c9                   	leave  
c0105192:	c3                   	ret    

c0105193 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105193:	55                   	push   %ebp
c0105194:	89 e5                	mov    %esp,%ebp
c0105196:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01051a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01051a7:	eb 04                	jmp    c01051ad <strtol+0x1a>
        s ++;
c01051a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01051ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b0:	0f b6 00             	movzbl (%eax),%eax
c01051b3:	3c 20                	cmp    $0x20,%al
c01051b5:	74 f2                	je     c01051a9 <strtol+0x16>
c01051b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ba:	0f b6 00             	movzbl (%eax),%eax
c01051bd:	3c 09                	cmp    $0x9,%al
c01051bf:	74 e8                	je     c01051a9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01051c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c4:	0f b6 00             	movzbl (%eax),%eax
c01051c7:	3c 2b                	cmp    $0x2b,%al
c01051c9:	75 06                	jne    c01051d1 <strtol+0x3e>
        s ++;
c01051cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051cf:	eb 15                	jmp    c01051e6 <strtol+0x53>
    }
    else if (*s == '-') {
c01051d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d4:	0f b6 00             	movzbl (%eax),%eax
c01051d7:	3c 2d                	cmp    $0x2d,%al
c01051d9:	75 0b                	jne    c01051e6 <strtol+0x53>
        s ++, neg = 1;
c01051db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01051e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051ea:	74 06                	je     c01051f2 <strtol+0x5f>
c01051ec:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01051f0:	75 24                	jne    c0105216 <strtol+0x83>
c01051f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f5:	0f b6 00             	movzbl (%eax),%eax
c01051f8:	3c 30                	cmp    $0x30,%al
c01051fa:	75 1a                	jne    c0105216 <strtol+0x83>
c01051fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ff:	83 c0 01             	add    $0x1,%eax
c0105202:	0f b6 00             	movzbl (%eax),%eax
c0105205:	3c 78                	cmp    $0x78,%al
c0105207:	75 0d                	jne    c0105216 <strtol+0x83>
        s += 2, base = 16;
c0105209:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010520d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105214:	eb 2a                	jmp    c0105240 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010521a:	75 17                	jne    c0105233 <strtol+0xa0>
c010521c:	8b 45 08             	mov    0x8(%ebp),%eax
c010521f:	0f b6 00             	movzbl (%eax),%eax
c0105222:	3c 30                	cmp    $0x30,%al
c0105224:	75 0d                	jne    c0105233 <strtol+0xa0>
        s ++, base = 8;
c0105226:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010522a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105231:	eb 0d                	jmp    c0105240 <strtol+0xad>
    }
    else if (base == 0) {
c0105233:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105237:	75 07                	jne    c0105240 <strtol+0xad>
        base = 10;
c0105239:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105240:	8b 45 08             	mov    0x8(%ebp),%eax
c0105243:	0f b6 00             	movzbl (%eax),%eax
c0105246:	3c 2f                	cmp    $0x2f,%al
c0105248:	7e 1b                	jle    c0105265 <strtol+0xd2>
c010524a:	8b 45 08             	mov    0x8(%ebp),%eax
c010524d:	0f b6 00             	movzbl (%eax),%eax
c0105250:	3c 39                	cmp    $0x39,%al
c0105252:	7f 11                	jg     c0105265 <strtol+0xd2>
            dig = *s - '0';
c0105254:	8b 45 08             	mov    0x8(%ebp),%eax
c0105257:	0f b6 00             	movzbl (%eax),%eax
c010525a:	0f be c0             	movsbl %al,%eax
c010525d:	83 e8 30             	sub    $0x30,%eax
c0105260:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105263:	eb 48                	jmp    c01052ad <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105265:	8b 45 08             	mov    0x8(%ebp),%eax
c0105268:	0f b6 00             	movzbl (%eax),%eax
c010526b:	3c 60                	cmp    $0x60,%al
c010526d:	7e 1b                	jle    c010528a <strtol+0xf7>
c010526f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105272:	0f b6 00             	movzbl (%eax),%eax
c0105275:	3c 7a                	cmp    $0x7a,%al
c0105277:	7f 11                	jg     c010528a <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105279:	8b 45 08             	mov    0x8(%ebp),%eax
c010527c:	0f b6 00             	movzbl (%eax),%eax
c010527f:	0f be c0             	movsbl %al,%eax
c0105282:	83 e8 57             	sub    $0x57,%eax
c0105285:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105288:	eb 23                	jmp    c01052ad <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010528a:	8b 45 08             	mov    0x8(%ebp),%eax
c010528d:	0f b6 00             	movzbl (%eax),%eax
c0105290:	3c 40                	cmp    $0x40,%al
c0105292:	7e 3c                	jle    c01052d0 <strtol+0x13d>
c0105294:	8b 45 08             	mov    0x8(%ebp),%eax
c0105297:	0f b6 00             	movzbl (%eax),%eax
c010529a:	3c 5a                	cmp    $0x5a,%al
c010529c:	7f 32                	jg     c01052d0 <strtol+0x13d>
            dig = *s - 'A' + 10;
c010529e:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a1:	0f b6 00             	movzbl (%eax),%eax
c01052a4:	0f be c0             	movsbl %al,%eax
c01052a7:	83 e8 37             	sub    $0x37,%eax
c01052aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01052ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052b0:	3b 45 10             	cmp    0x10(%ebp),%eax
c01052b3:	7d 1a                	jge    c01052cf <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01052b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01052b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052bc:	0f af 45 10          	imul   0x10(%ebp),%eax
c01052c0:	89 c2                	mov    %eax,%edx
c01052c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052c5:	01 d0                	add    %edx,%eax
c01052c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01052ca:	e9 71 ff ff ff       	jmp    c0105240 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01052cf:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01052d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01052d4:	74 08                	je     c01052de <strtol+0x14b>
        *endptr = (char *) s;
c01052d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01052dc:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01052de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01052e2:	74 07                	je     c01052eb <strtol+0x158>
c01052e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052e7:	f7 d8                	neg    %eax
c01052e9:	eb 03                	jmp    c01052ee <strtol+0x15b>
c01052eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01052ee:	c9                   	leave  
c01052ef:	c3                   	ret    

c01052f0 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01052f0:	55                   	push   %ebp
c01052f1:	89 e5                	mov    %esp,%ebp
c01052f3:	57                   	push   %edi
c01052f4:	83 ec 24             	sub    $0x24,%esp
c01052f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052fa:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01052fd:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105301:	8b 55 08             	mov    0x8(%ebp),%edx
c0105304:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105307:	88 45 f7             	mov    %al,-0x9(%ebp)
c010530a:	8b 45 10             	mov    0x10(%ebp),%eax
c010530d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105310:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105313:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105317:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010531a:	89 d7                	mov    %edx,%edi
c010531c:	f3 aa                	rep stos %al,%es:(%edi)
c010531e:	89 fa                	mov    %edi,%edx
c0105320:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105323:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105326:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105329:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010532a:	83 c4 24             	add    $0x24,%esp
c010532d:	5f                   	pop    %edi
c010532e:	5d                   	pop    %ebp
c010532f:	c3                   	ret    

c0105330 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105330:	55                   	push   %ebp
c0105331:	89 e5                	mov    %esp,%ebp
c0105333:	57                   	push   %edi
c0105334:	56                   	push   %esi
c0105335:	53                   	push   %ebx
c0105336:	83 ec 30             	sub    $0x30,%esp
c0105339:	8b 45 08             	mov    0x8(%ebp),%eax
c010533c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010533f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105342:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105345:	8b 45 10             	mov    0x10(%ebp),%eax
c0105348:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010534b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010534e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105351:	73 42                	jae    c0105395 <memmove+0x65>
c0105353:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105359:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010535c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010535f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105362:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105365:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105368:	c1 e8 02             	shr    $0x2,%eax
c010536b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010536d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105370:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105373:	89 d7                	mov    %edx,%edi
c0105375:	89 c6                	mov    %eax,%esi
c0105377:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105379:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010537c:	83 e1 03             	and    $0x3,%ecx
c010537f:	74 02                	je     c0105383 <memmove+0x53>
c0105381:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105383:	89 f0                	mov    %esi,%eax
c0105385:	89 fa                	mov    %edi,%edx
c0105387:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010538a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010538d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105393:	eb 36                	jmp    c01053cb <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105395:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105398:	8d 50 ff             	lea    -0x1(%eax),%edx
c010539b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010539e:	01 c2                	add    %eax,%edx
c01053a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053a3:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01053a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053a9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01053ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053af:	89 c1                	mov    %eax,%ecx
c01053b1:	89 d8                	mov    %ebx,%eax
c01053b3:	89 d6                	mov    %edx,%esi
c01053b5:	89 c7                	mov    %eax,%edi
c01053b7:	fd                   	std    
c01053b8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01053ba:	fc                   	cld    
c01053bb:	89 f8                	mov    %edi,%eax
c01053bd:	89 f2                	mov    %esi,%edx
c01053bf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01053c2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01053c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01053c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01053cb:	83 c4 30             	add    $0x30,%esp
c01053ce:	5b                   	pop    %ebx
c01053cf:	5e                   	pop    %esi
c01053d0:	5f                   	pop    %edi
c01053d1:	5d                   	pop    %ebp
c01053d2:	c3                   	ret    

c01053d3 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01053d3:	55                   	push   %ebp
c01053d4:	89 e5                	mov    %esp,%ebp
c01053d6:	57                   	push   %edi
c01053d7:	56                   	push   %esi
c01053d8:	83 ec 20             	sub    $0x20,%esp
c01053db:	8b 45 08             	mov    0x8(%ebp),%eax
c01053de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01053ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01053ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053f0:	c1 e8 02             	shr    $0x2,%eax
c01053f3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01053f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053fb:	89 d7                	mov    %edx,%edi
c01053fd:	89 c6                	mov    %eax,%esi
c01053ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105401:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105404:	83 e1 03             	and    $0x3,%ecx
c0105407:	74 02                	je     c010540b <memcpy+0x38>
c0105409:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010540b:	89 f0                	mov    %esi,%eax
c010540d:	89 fa                	mov    %edi,%edx
c010540f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105412:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105415:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105418:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010541b:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010541c:	83 c4 20             	add    $0x20,%esp
c010541f:	5e                   	pop    %esi
c0105420:	5f                   	pop    %edi
c0105421:	5d                   	pop    %ebp
c0105422:	c3                   	ret    

c0105423 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105423:	55                   	push   %ebp
c0105424:	89 e5                	mov    %esp,%ebp
c0105426:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105429:	8b 45 08             	mov    0x8(%ebp),%eax
c010542c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010542f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105432:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105435:	eb 30                	jmp    c0105467 <memcmp+0x44>
        if (*s1 != *s2) {
c0105437:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010543a:	0f b6 10             	movzbl (%eax),%edx
c010543d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105440:	0f b6 00             	movzbl (%eax),%eax
c0105443:	38 c2                	cmp    %al,%dl
c0105445:	74 18                	je     c010545f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105447:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010544a:	0f b6 00             	movzbl (%eax),%eax
c010544d:	0f b6 d0             	movzbl %al,%edx
c0105450:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105453:	0f b6 00             	movzbl (%eax),%eax
c0105456:	0f b6 c0             	movzbl %al,%eax
c0105459:	29 c2                	sub    %eax,%edx
c010545b:	89 d0                	mov    %edx,%eax
c010545d:	eb 1a                	jmp    c0105479 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010545f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105463:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105467:	8b 45 10             	mov    0x10(%ebp),%eax
c010546a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010546d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105470:	85 c0                	test   %eax,%eax
c0105472:	75 c3                	jne    c0105437 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105474:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105479:	c9                   	leave  
c010547a:	c3                   	ret    

c010547b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010547b:	55                   	push   %ebp
c010547c:	89 e5                	mov    %esp,%ebp
c010547e:	83 ec 38             	sub    $0x38,%esp
c0105481:	8b 45 10             	mov    0x10(%ebp),%eax
c0105484:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105487:	8b 45 14             	mov    0x14(%ebp),%eax
c010548a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010548d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105490:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105493:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105496:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105499:	8b 45 18             	mov    0x18(%ebp),%eax
c010549c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010549f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054a8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054b5:	74 1c                	je     c01054d3 <printnum+0x58>
c01054b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054ba:	ba 00 00 00 00       	mov    $0x0,%edx
c01054bf:	f7 75 e4             	divl   -0x1c(%ebp)
c01054c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054c8:	ba 00 00 00 00       	mov    $0x0,%edx
c01054cd:	f7 75 e4             	divl   -0x1c(%ebp)
c01054d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054d9:	f7 75 e4             	divl   -0x1c(%ebp)
c01054dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054df:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054eb:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054f4:	8b 45 18             	mov    0x18(%ebp),%eax
c01054f7:	ba 00 00 00 00       	mov    $0x0,%edx
c01054fc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054ff:	77 41                	ja     c0105542 <printnum+0xc7>
c0105501:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105504:	72 05                	jb     c010550b <printnum+0x90>
c0105506:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105509:	77 37                	ja     c0105542 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c010550b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010550e:	83 e8 01             	sub    $0x1,%eax
c0105511:	83 ec 04             	sub    $0x4,%esp
c0105514:	ff 75 20             	pushl  0x20(%ebp)
c0105517:	50                   	push   %eax
c0105518:	ff 75 18             	pushl  0x18(%ebp)
c010551b:	ff 75 ec             	pushl  -0x14(%ebp)
c010551e:	ff 75 e8             	pushl  -0x18(%ebp)
c0105521:	ff 75 0c             	pushl  0xc(%ebp)
c0105524:	ff 75 08             	pushl  0x8(%ebp)
c0105527:	e8 4f ff ff ff       	call   c010547b <printnum>
c010552c:	83 c4 20             	add    $0x20,%esp
c010552f:	eb 1b                	jmp    c010554c <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105531:	83 ec 08             	sub    $0x8,%esp
c0105534:	ff 75 0c             	pushl  0xc(%ebp)
c0105537:	ff 75 20             	pushl  0x20(%ebp)
c010553a:	8b 45 08             	mov    0x8(%ebp),%eax
c010553d:	ff d0                	call   *%eax
c010553f:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105542:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105546:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010554a:	7f e5                	jg     c0105531 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010554c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010554f:	05 34 6c 10 c0       	add    $0xc0106c34,%eax
c0105554:	0f b6 00             	movzbl (%eax),%eax
c0105557:	0f be c0             	movsbl %al,%eax
c010555a:	83 ec 08             	sub    $0x8,%esp
c010555d:	ff 75 0c             	pushl  0xc(%ebp)
c0105560:	50                   	push   %eax
c0105561:	8b 45 08             	mov    0x8(%ebp),%eax
c0105564:	ff d0                	call   *%eax
c0105566:	83 c4 10             	add    $0x10,%esp
}
c0105569:	90                   	nop
c010556a:	c9                   	leave  
c010556b:	c3                   	ret    

c010556c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010556c:	55                   	push   %ebp
c010556d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010556f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105573:	7e 14                	jle    c0105589 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105575:	8b 45 08             	mov    0x8(%ebp),%eax
c0105578:	8b 00                	mov    (%eax),%eax
c010557a:	8d 48 08             	lea    0x8(%eax),%ecx
c010557d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105580:	89 0a                	mov    %ecx,(%edx)
c0105582:	8b 50 04             	mov    0x4(%eax),%edx
c0105585:	8b 00                	mov    (%eax),%eax
c0105587:	eb 30                	jmp    c01055b9 <getuint+0x4d>
    }
    else if (lflag) {
c0105589:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010558d:	74 16                	je     c01055a5 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010558f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105592:	8b 00                	mov    (%eax),%eax
c0105594:	8d 48 04             	lea    0x4(%eax),%ecx
c0105597:	8b 55 08             	mov    0x8(%ebp),%edx
c010559a:	89 0a                	mov    %ecx,(%edx)
c010559c:	8b 00                	mov    (%eax),%eax
c010559e:	ba 00 00 00 00       	mov    $0x0,%edx
c01055a3:	eb 14                	jmp    c01055b9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a8:	8b 00                	mov    (%eax),%eax
c01055aa:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01055b0:	89 0a                	mov    %ecx,(%edx)
c01055b2:	8b 00                	mov    (%eax),%eax
c01055b4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055b9:	5d                   	pop    %ebp
c01055ba:	c3                   	ret    

c01055bb <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055bb:	55                   	push   %ebp
c01055bc:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055c2:	7e 14                	jle    c01055d8 <getint+0x1d>
        return va_arg(*ap, long long);
c01055c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c7:	8b 00                	mov    (%eax),%eax
c01055c9:	8d 48 08             	lea    0x8(%eax),%ecx
c01055cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01055cf:	89 0a                	mov    %ecx,(%edx)
c01055d1:	8b 50 04             	mov    0x4(%eax),%edx
c01055d4:	8b 00                	mov    (%eax),%eax
c01055d6:	eb 28                	jmp    c0105600 <getint+0x45>
    }
    else if (lflag) {
c01055d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055dc:	74 12                	je     c01055f0 <getint+0x35>
        return va_arg(*ap, long);
c01055de:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e1:	8b 00                	mov    (%eax),%eax
c01055e3:	8d 48 04             	lea    0x4(%eax),%ecx
c01055e6:	8b 55 08             	mov    0x8(%ebp),%edx
c01055e9:	89 0a                	mov    %ecx,(%edx)
c01055eb:	8b 00                	mov    (%eax),%eax
c01055ed:	99                   	cltd   
c01055ee:	eb 10                	jmp    c0105600 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f3:	8b 00                	mov    (%eax),%eax
c01055f5:	8d 48 04             	lea    0x4(%eax),%ecx
c01055f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055fb:	89 0a                	mov    %ecx,(%edx)
c01055fd:	8b 00                	mov    (%eax),%eax
c01055ff:	99                   	cltd   
    }
}
c0105600:	5d                   	pop    %ebp
c0105601:	c3                   	ret    

c0105602 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105602:	55                   	push   %ebp
c0105603:	89 e5                	mov    %esp,%ebp
c0105605:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c0105608:	8d 45 14             	lea    0x14(%ebp),%eax
c010560b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010560e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105611:	50                   	push   %eax
c0105612:	ff 75 10             	pushl  0x10(%ebp)
c0105615:	ff 75 0c             	pushl  0xc(%ebp)
c0105618:	ff 75 08             	pushl  0x8(%ebp)
c010561b:	e8 06 00 00 00       	call   c0105626 <vprintfmt>
c0105620:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105623:	90                   	nop
c0105624:	c9                   	leave  
c0105625:	c3                   	ret    

c0105626 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105626:	55                   	push   %ebp
c0105627:	89 e5                	mov    %esp,%ebp
c0105629:	56                   	push   %esi
c010562a:	53                   	push   %ebx
c010562b:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010562e:	eb 17                	jmp    c0105647 <vprintfmt+0x21>
            if (ch == '\0') {
c0105630:	85 db                	test   %ebx,%ebx
c0105632:	0f 84 8e 03 00 00    	je     c01059c6 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105638:	83 ec 08             	sub    $0x8,%esp
c010563b:	ff 75 0c             	pushl  0xc(%ebp)
c010563e:	53                   	push   %ebx
c010563f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105642:	ff d0                	call   *%eax
c0105644:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105647:	8b 45 10             	mov    0x10(%ebp),%eax
c010564a:	8d 50 01             	lea    0x1(%eax),%edx
c010564d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105650:	0f b6 00             	movzbl (%eax),%eax
c0105653:	0f b6 d8             	movzbl %al,%ebx
c0105656:	83 fb 25             	cmp    $0x25,%ebx
c0105659:	75 d5                	jne    c0105630 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010565b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010565f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105669:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010566c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105673:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105676:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105679:	8b 45 10             	mov    0x10(%ebp),%eax
c010567c:	8d 50 01             	lea    0x1(%eax),%edx
c010567f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105682:	0f b6 00             	movzbl (%eax),%eax
c0105685:	0f b6 d8             	movzbl %al,%ebx
c0105688:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010568b:	83 f8 55             	cmp    $0x55,%eax
c010568e:	0f 87 05 03 00 00    	ja     c0105999 <vprintfmt+0x373>
c0105694:	8b 04 85 58 6c 10 c0 	mov    -0x3fef93a8(,%eax,4),%eax
c010569b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010569d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056a1:	eb d6                	jmp    c0105679 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056a7:	eb d0                	jmp    c0105679 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056b3:	89 d0                	mov    %edx,%eax
c01056b5:	c1 e0 02             	shl    $0x2,%eax
c01056b8:	01 d0                	add    %edx,%eax
c01056ba:	01 c0                	add    %eax,%eax
c01056bc:	01 d8                	add    %ebx,%eax
c01056be:	83 e8 30             	sub    $0x30,%eax
c01056c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c7:	0f b6 00             	movzbl (%eax),%eax
c01056ca:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056cd:	83 fb 2f             	cmp    $0x2f,%ebx
c01056d0:	7e 39                	jle    c010570b <vprintfmt+0xe5>
c01056d2:	83 fb 39             	cmp    $0x39,%ebx
c01056d5:	7f 34                	jg     c010570b <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056d7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056db:	eb d3                	jmp    c01056b0 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e0:	8d 50 04             	lea    0x4(%eax),%edx
c01056e3:	89 55 14             	mov    %edx,0x14(%ebp)
c01056e6:	8b 00                	mov    (%eax),%eax
c01056e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056eb:	eb 1f                	jmp    c010570c <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01056ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056f1:	79 86                	jns    c0105679 <vprintfmt+0x53>
                width = 0;
c01056f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056fa:	e9 7a ff ff ff       	jmp    c0105679 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01056ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105706:	e9 6e ff ff ff       	jmp    c0105679 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c010570b:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c010570c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105710:	0f 89 63 ff ff ff    	jns    c0105679 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105719:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010571c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105723:	e9 51 ff ff ff       	jmp    c0105679 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105728:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010572c:	e9 48 ff ff ff       	jmp    c0105679 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105731:	8b 45 14             	mov    0x14(%ebp),%eax
c0105734:	8d 50 04             	lea    0x4(%eax),%edx
c0105737:	89 55 14             	mov    %edx,0x14(%ebp)
c010573a:	8b 00                	mov    (%eax),%eax
c010573c:	83 ec 08             	sub    $0x8,%esp
c010573f:	ff 75 0c             	pushl  0xc(%ebp)
c0105742:	50                   	push   %eax
c0105743:	8b 45 08             	mov    0x8(%ebp),%eax
c0105746:	ff d0                	call   *%eax
c0105748:	83 c4 10             	add    $0x10,%esp
            break;
c010574b:	e9 71 02 00 00       	jmp    c01059c1 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105750:	8b 45 14             	mov    0x14(%ebp),%eax
c0105753:	8d 50 04             	lea    0x4(%eax),%edx
c0105756:	89 55 14             	mov    %edx,0x14(%ebp)
c0105759:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010575b:	85 db                	test   %ebx,%ebx
c010575d:	79 02                	jns    c0105761 <vprintfmt+0x13b>
                err = -err;
c010575f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105761:	83 fb 06             	cmp    $0x6,%ebx
c0105764:	7f 0b                	jg     c0105771 <vprintfmt+0x14b>
c0105766:	8b 34 9d 18 6c 10 c0 	mov    -0x3fef93e8(,%ebx,4),%esi
c010576d:	85 f6                	test   %esi,%esi
c010576f:	75 19                	jne    c010578a <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c0105771:	53                   	push   %ebx
c0105772:	68 45 6c 10 c0       	push   $0xc0106c45
c0105777:	ff 75 0c             	pushl  0xc(%ebp)
c010577a:	ff 75 08             	pushl  0x8(%ebp)
c010577d:	e8 80 fe ff ff       	call   c0105602 <printfmt>
c0105782:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105785:	e9 37 02 00 00       	jmp    c01059c1 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010578a:	56                   	push   %esi
c010578b:	68 4e 6c 10 c0       	push   $0xc0106c4e
c0105790:	ff 75 0c             	pushl  0xc(%ebp)
c0105793:	ff 75 08             	pushl  0x8(%ebp)
c0105796:	e8 67 fe ff ff       	call   c0105602 <printfmt>
c010579b:	83 c4 10             	add    $0x10,%esp
            }
            break;
c010579e:	e9 1e 02 00 00       	jmp    c01059c1 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01057a6:	8d 50 04             	lea    0x4(%eax),%edx
c01057a9:	89 55 14             	mov    %edx,0x14(%ebp)
c01057ac:	8b 30                	mov    (%eax),%esi
c01057ae:	85 f6                	test   %esi,%esi
c01057b0:	75 05                	jne    c01057b7 <vprintfmt+0x191>
                p = "(null)";
c01057b2:	be 51 6c 10 c0       	mov    $0xc0106c51,%esi
            }
            if (width > 0 && padc != '-') {
c01057b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057bb:	7e 76                	jle    c0105833 <vprintfmt+0x20d>
c01057bd:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057c1:	74 70                	je     c0105833 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057c6:	83 ec 08             	sub    $0x8,%esp
c01057c9:	50                   	push   %eax
c01057ca:	56                   	push   %esi
c01057cb:	e8 17 f8 ff ff       	call   c0104fe7 <strnlen>
c01057d0:	83 c4 10             	add    $0x10,%esp
c01057d3:	89 c2                	mov    %eax,%edx
c01057d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057d8:	29 d0                	sub    %edx,%eax
c01057da:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057dd:	eb 17                	jmp    c01057f6 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01057df:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057e3:	83 ec 08             	sub    $0x8,%esp
c01057e6:	ff 75 0c             	pushl  0xc(%ebp)
c01057e9:	50                   	push   %eax
c01057ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ed:	ff d0                	call   *%eax
c01057ef:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057f2:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057fa:	7f e3                	jg     c01057df <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057fc:	eb 35                	jmp    c0105833 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105802:	74 1c                	je     c0105820 <vprintfmt+0x1fa>
c0105804:	83 fb 1f             	cmp    $0x1f,%ebx
c0105807:	7e 05                	jle    c010580e <vprintfmt+0x1e8>
c0105809:	83 fb 7e             	cmp    $0x7e,%ebx
c010580c:	7e 12                	jle    c0105820 <vprintfmt+0x1fa>
                    putch('?', putdat);
c010580e:	83 ec 08             	sub    $0x8,%esp
c0105811:	ff 75 0c             	pushl  0xc(%ebp)
c0105814:	6a 3f                	push   $0x3f
c0105816:	8b 45 08             	mov    0x8(%ebp),%eax
c0105819:	ff d0                	call   *%eax
c010581b:	83 c4 10             	add    $0x10,%esp
c010581e:	eb 0f                	jmp    c010582f <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105820:	83 ec 08             	sub    $0x8,%esp
c0105823:	ff 75 0c             	pushl  0xc(%ebp)
c0105826:	53                   	push   %ebx
c0105827:	8b 45 08             	mov    0x8(%ebp),%eax
c010582a:	ff d0                	call   *%eax
c010582c:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010582f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105833:	89 f0                	mov    %esi,%eax
c0105835:	8d 70 01             	lea    0x1(%eax),%esi
c0105838:	0f b6 00             	movzbl (%eax),%eax
c010583b:	0f be d8             	movsbl %al,%ebx
c010583e:	85 db                	test   %ebx,%ebx
c0105840:	74 26                	je     c0105868 <vprintfmt+0x242>
c0105842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105846:	78 b6                	js     c01057fe <vprintfmt+0x1d8>
c0105848:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010584c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105850:	79 ac                	jns    c01057fe <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105852:	eb 14                	jmp    c0105868 <vprintfmt+0x242>
                putch(' ', putdat);
c0105854:	83 ec 08             	sub    $0x8,%esp
c0105857:	ff 75 0c             	pushl  0xc(%ebp)
c010585a:	6a 20                	push   $0x20
c010585c:	8b 45 08             	mov    0x8(%ebp),%eax
c010585f:	ff d0                	call   *%eax
c0105861:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105864:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105868:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010586c:	7f e6                	jg     c0105854 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c010586e:	e9 4e 01 00 00       	jmp    c01059c1 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105873:	83 ec 08             	sub    $0x8,%esp
c0105876:	ff 75 e0             	pushl  -0x20(%ebp)
c0105879:	8d 45 14             	lea    0x14(%ebp),%eax
c010587c:	50                   	push   %eax
c010587d:	e8 39 fd ff ff       	call   c01055bb <getint>
c0105882:	83 c4 10             	add    $0x10,%esp
c0105885:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105888:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010588b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010588e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105891:	85 d2                	test   %edx,%edx
c0105893:	79 23                	jns    c01058b8 <vprintfmt+0x292>
                putch('-', putdat);
c0105895:	83 ec 08             	sub    $0x8,%esp
c0105898:	ff 75 0c             	pushl  0xc(%ebp)
c010589b:	6a 2d                	push   $0x2d
c010589d:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a0:	ff d0                	call   *%eax
c01058a2:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01058a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058ab:	f7 d8                	neg    %eax
c01058ad:	83 d2 00             	adc    $0x0,%edx
c01058b0:	f7 da                	neg    %edx
c01058b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058bf:	e9 9f 00 00 00       	jmp    c0105963 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058c4:	83 ec 08             	sub    $0x8,%esp
c01058c7:	ff 75 e0             	pushl  -0x20(%ebp)
c01058ca:	8d 45 14             	lea    0x14(%ebp),%eax
c01058cd:	50                   	push   %eax
c01058ce:	e8 99 fc ff ff       	call   c010556c <getuint>
c01058d3:	83 c4 10             	add    $0x10,%esp
c01058d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058e3:	eb 7e                	jmp    c0105963 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058e5:	83 ec 08             	sub    $0x8,%esp
c01058e8:	ff 75 e0             	pushl  -0x20(%ebp)
c01058eb:	8d 45 14             	lea    0x14(%ebp),%eax
c01058ee:	50                   	push   %eax
c01058ef:	e8 78 fc ff ff       	call   c010556c <getuint>
c01058f4:	83 c4 10             	add    $0x10,%esp
c01058f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058fd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105904:	eb 5d                	jmp    c0105963 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c0105906:	83 ec 08             	sub    $0x8,%esp
c0105909:	ff 75 0c             	pushl  0xc(%ebp)
c010590c:	6a 30                	push   $0x30
c010590e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105911:	ff d0                	call   *%eax
c0105913:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105916:	83 ec 08             	sub    $0x8,%esp
c0105919:	ff 75 0c             	pushl  0xc(%ebp)
c010591c:	6a 78                	push   $0x78
c010591e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105921:	ff d0                	call   *%eax
c0105923:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105926:	8b 45 14             	mov    0x14(%ebp),%eax
c0105929:	8d 50 04             	lea    0x4(%eax),%edx
c010592c:	89 55 14             	mov    %edx,0x14(%ebp)
c010592f:	8b 00                	mov    (%eax),%eax
c0105931:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010593b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105942:	eb 1f                	jmp    c0105963 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105944:	83 ec 08             	sub    $0x8,%esp
c0105947:	ff 75 e0             	pushl  -0x20(%ebp)
c010594a:	8d 45 14             	lea    0x14(%ebp),%eax
c010594d:	50                   	push   %eax
c010594e:	e8 19 fc ff ff       	call   c010556c <getuint>
c0105953:	83 c4 10             	add    $0x10,%esp
c0105956:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105959:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010595c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105963:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010596a:	83 ec 04             	sub    $0x4,%esp
c010596d:	52                   	push   %edx
c010596e:	ff 75 e8             	pushl  -0x18(%ebp)
c0105971:	50                   	push   %eax
c0105972:	ff 75 f4             	pushl  -0xc(%ebp)
c0105975:	ff 75 f0             	pushl  -0x10(%ebp)
c0105978:	ff 75 0c             	pushl  0xc(%ebp)
c010597b:	ff 75 08             	pushl  0x8(%ebp)
c010597e:	e8 f8 fa ff ff       	call   c010547b <printnum>
c0105983:	83 c4 20             	add    $0x20,%esp
            break;
c0105986:	eb 39                	jmp    c01059c1 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105988:	83 ec 08             	sub    $0x8,%esp
c010598b:	ff 75 0c             	pushl  0xc(%ebp)
c010598e:	53                   	push   %ebx
c010598f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105992:	ff d0                	call   *%eax
c0105994:	83 c4 10             	add    $0x10,%esp
            break;
c0105997:	eb 28                	jmp    c01059c1 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105999:	83 ec 08             	sub    $0x8,%esp
c010599c:	ff 75 0c             	pushl  0xc(%ebp)
c010599f:	6a 25                	push   $0x25
c01059a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a4:	ff d0                	call   *%eax
c01059a6:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059a9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059ad:	eb 04                	jmp    c01059b3 <vprintfmt+0x38d>
c01059af:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01059b6:	83 e8 01             	sub    $0x1,%eax
c01059b9:	0f b6 00             	movzbl (%eax),%eax
c01059bc:	3c 25                	cmp    $0x25,%al
c01059be:	75 ef                	jne    c01059af <vprintfmt+0x389>
                /* do nothing */;
            break;
c01059c0:	90                   	nop
        }
    }
c01059c1:	e9 68 fc ff ff       	jmp    c010562e <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c01059c6:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01059ca:	5b                   	pop    %ebx
c01059cb:	5e                   	pop    %esi
c01059cc:	5d                   	pop    %ebp
c01059cd:	c3                   	ret    

c01059ce <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059ce:	55                   	push   %ebp
c01059cf:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d4:	8b 40 08             	mov    0x8(%eax),%eax
c01059d7:	8d 50 01             	lea    0x1(%eax),%edx
c01059da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059dd:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e3:	8b 10                	mov    (%eax),%edx
c01059e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e8:	8b 40 04             	mov    0x4(%eax),%eax
c01059eb:	39 c2                	cmp    %eax,%edx
c01059ed:	73 12                	jae    c0105a01 <sprintputch+0x33>
        *b->buf ++ = ch;
c01059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f2:	8b 00                	mov    (%eax),%eax
c01059f4:	8d 48 01             	lea    0x1(%eax),%ecx
c01059f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059fa:	89 0a                	mov    %ecx,(%edx)
c01059fc:	8b 55 08             	mov    0x8(%ebp),%edx
c01059ff:	88 10                	mov    %dl,(%eax)
    }
}
c0105a01:	90                   	nop
c0105a02:	5d                   	pop    %ebp
c0105a03:	c3                   	ret    

c0105a04 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a04:	55                   	push   %ebp
c0105a05:	89 e5                	mov    %esp,%ebp
c0105a07:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a0a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a13:	50                   	push   %eax
c0105a14:	ff 75 10             	pushl  0x10(%ebp)
c0105a17:	ff 75 0c             	pushl  0xc(%ebp)
c0105a1a:	ff 75 08             	pushl  0x8(%ebp)
c0105a1d:	e8 0b 00 00 00       	call   c0105a2d <vsnprintf>
c0105a22:	83 c4 10             	add    $0x10,%esp
c0105a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a2b:	c9                   	leave  
c0105a2c:	c3                   	ret    

c0105a2d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a2d:	55                   	push   %ebp
c0105a2e:	89 e5                	mov    %esp,%ebp
c0105a30:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a3c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a42:	01 d0                	add    %edx,%eax
c0105a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a52:	74 0a                	je     c0105a5e <vsnprintf+0x31>
c0105a54:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a5a:	39 c2                	cmp    %eax,%edx
c0105a5c:	76 07                	jbe    c0105a65 <vsnprintf+0x38>
        return -E_INVAL;
c0105a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a63:	eb 20                	jmp    c0105a85 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a65:	ff 75 14             	pushl  0x14(%ebp)
c0105a68:	ff 75 10             	pushl  0x10(%ebp)
c0105a6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a6e:	50                   	push   %eax
c0105a6f:	68 ce 59 10 c0       	push   $0xc01059ce
c0105a74:	e8 ad fb ff ff       	call   c0105626 <vprintfmt>
c0105a79:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a7f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a85:	c9                   	leave  
c0105a86:	c3                   	ret    
