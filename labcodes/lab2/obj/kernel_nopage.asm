
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 7a 11 00       	push   $0x117a36
  100049:	e8 e7 50 00 00       	call   105135 <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 60 15 00 00       	call   1015b6 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 e0 58 10 00 	movl   $0x1058e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 fc 58 10 00       	push   $0x1058fc
  100068:	e8 ff 01 00 00       	call   10026c <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 81 08 00 00       	call   1008f6 <print_kerninfo>

    grade_backtrace();
  100075:	e8 79 00 00 00       	call   1000f3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 15 31 00 00       	call   103194 <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 a4 16 00 00       	call   101728 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 26 18 00 00       	call   1018af <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 cf 0c 00 00       	call   100d5d <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 d2 17 00 00       	call   101865 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100093:	e8 45 01 00 00       	call   1001dd <lab1_switch_test>

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	83 ec 04             	sub    $0x4,%esp
  1000a3:	6a 00                	push   $0x0
  1000a5:	6a 00                	push   $0x0
  1000a7:	6a 00                	push   $0x0
  1000a9:	e8 9d 0c 00 00       	call   100d4b <mon_backtrace>
  1000ae:	83 c4 10             	add    $0x10,%esp
}
  1000b1:	90                   	nop
  1000b2:	c9                   	leave  
  1000b3:	c3                   	ret    

001000b4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000b4:	55                   	push   %ebp
  1000b5:	89 e5                	mov    %esp,%ebp
  1000b7:	53                   	push   %ebx
  1000b8:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000bb:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000be:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000c1:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c7:	51                   	push   %ecx
  1000c8:	52                   	push   %edx
  1000c9:	53                   	push   %ebx
  1000ca:	50                   	push   %eax
  1000cb:	e8 ca ff ff ff       	call   10009a <grade_backtrace2>
  1000d0:	83 c4 10             	add    $0x10,%esp
}
  1000d3:	90                   	nop
  1000d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d7:	c9                   	leave  
  1000d8:	c3                   	ret    

001000d9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d9:	55                   	push   %ebp
  1000da:	89 e5                	mov    %esp,%ebp
  1000dc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000df:	83 ec 08             	sub    $0x8,%esp
  1000e2:	ff 75 10             	pushl  0x10(%ebp)
  1000e5:	ff 75 08             	pushl  0x8(%ebp)
  1000e8:	e8 c7 ff ff ff       	call   1000b4 <grade_backtrace1>
  1000ed:	83 c4 10             	add    $0x10,%esp
}
  1000f0:	90                   	nop
  1000f1:	c9                   	leave  
  1000f2:	c3                   	ret    

001000f3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000fe:	83 ec 04             	sub    $0x4,%esp
  100101:	68 00 00 ff ff       	push   $0xffff0000
  100106:	50                   	push   %eax
  100107:	6a 00                	push   $0x0
  100109:	e8 cb ff ff ff       	call   1000d9 <grade_backtrace0>
  10010e:	83 c4 10             	add    $0x10,%esp
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100114:	55                   	push   %ebp
  100115:	89 e5                	mov    %esp,%ebp
  100117:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10011a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10011d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100120:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100123:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100126:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10012a:	0f b7 c0             	movzwl %ax,%eax
  10012d:	83 e0 03             	and    $0x3,%eax
  100130:	89 c2                	mov    %eax,%edx
  100132:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100137:	83 ec 04             	sub    $0x4,%esp
  10013a:	52                   	push   %edx
  10013b:	50                   	push   %eax
  10013c:	68 01 59 10 00       	push   $0x105901
  100141:	e8 26 01 00 00       	call   10026c <cprintf>
  100146:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100149:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014d:	0f b7 d0             	movzwl %ax,%edx
  100150:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100155:	83 ec 04             	sub    $0x4,%esp
  100158:	52                   	push   %edx
  100159:	50                   	push   %eax
  10015a:	68 0f 59 10 00       	push   $0x10590f
  10015f:	e8 08 01 00 00       	call   10026c <cprintf>
  100164:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100167:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10016b:	0f b7 d0             	movzwl %ax,%edx
  10016e:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100173:	83 ec 04             	sub    $0x4,%esp
  100176:	52                   	push   %edx
  100177:	50                   	push   %eax
  100178:	68 1d 59 10 00       	push   $0x10591d
  10017d:	e8 ea 00 00 00       	call   10026c <cprintf>
  100182:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100185:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100189:	0f b7 d0             	movzwl %ax,%edx
  10018c:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100191:	83 ec 04             	sub    $0x4,%esp
  100194:	52                   	push   %edx
  100195:	50                   	push   %eax
  100196:	68 2b 59 10 00       	push   $0x10592b
  10019b:	e8 cc 00 00 00       	call   10026c <cprintf>
  1001a0:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  1001a3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a7:	0f b7 d0             	movzwl %ax,%edx
  1001aa:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001af:	83 ec 04             	sub    $0x4,%esp
  1001b2:	52                   	push   %edx
  1001b3:	50                   	push   %eax
  1001b4:	68 39 59 10 00       	push   $0x105939
  1001b9:	e8 ae 00 00 00       	call   10026c <cprintf>
  1001be:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001c1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001c6:	83 c0 01             	add    $0x1,%eax
  1001c9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ce:	90                   	nop
  1001cf:	c9                   	leave  
  1001d0:	c3                   	ret    

001001d1 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001d1:	55                   	push   %ebp
  1001d2:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001d4:	90                   	nop
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001da:	90                   	nop
  1001db:	5d                   	pop    %ebp
  1001dc:	c3                   	ret    

001001dd <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001dd:	55                   	push   %ebp
  1001de:	89 e5                	mov    %esp,%ebp
  1001e0:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001e3:	e8 2c ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e8:	83 ec 0c             	sub    $0xc,%esp
  1001eb:	68 48 59 10 00       	push   $0x105948
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
  1001f5:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f8:	e8 d4 ff ff ff       	call   1001d1 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fd:	e8 12 ff ff ff       	call   100114 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100202:	83 ec 0c             	sub    $0xc,%esp
  100205:	68 68 59 10 00       	push   $0x105968
  10020a:	e8 5d 00 00 00       	call   10026c <cprintf>
  10020f:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  100212:	e8 c0 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100217:	e8 f8 fe ff ff       	call   100114 <lab1_print_cur_status>
}
  10021c:	90                   	nop
  10021d:	c9                   	leave  
  10021e:	c3                   	ret    

0010021f <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021f:	55                   	push   %ebp
  100220:	89 e5                	mov    %esp,%ebp
  100222:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100225:	83 ec 0c             	sub    $0xc,%esp
  100228:	ff 75 08             	pushl  0x8(%ebp)
  10022b:	e8 b7 13 00 00       	call   1015e7 <cons_putc>
  100230:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100233:	8b 45 0c             	mov    0xc(%ebp),%eax
  100236:	8b 00                	mov    (%eax),%eax
  100238:	8d 50 01             	lea    0x1(%eax),%edx
  10023b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023e:	89 10                	mov    %edx,(%eax)
}
  100240:	90                   	nop
  100241:	c9                   	leave  
  100242:	c3                   	ret    

00100243 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100243:	55                   	push   %ebp
  100244:	89 e5                	mov    %esp,%ebp
  100246:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100250:	ff 75 0c             	pushl  0xc(%ebp)
  100253:	ff 75 08             	pushl  0x8(%ebp)
  100256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100259:	50                   	push   %eax
  10025a:	68 1f 02 10 00       	push   $0x10021f
  10025f:	e8 07 52 00 00       	call   10546b <vprintfmt>
  100264:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	83 ec 08             	sub    $0x8,%esp
  10027e:	50                   	push   %eax
  10027f:	ff 75 08             	pushl  0x8(%ebp)
  100282:	e8 bc ff ff ff       	call   100243 <vcprintf>
  100287:	83 c4 10             	add    $0x10,%esp
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100298:	83 ec 0c             	sub    $0xc,%esp
  10029b:	ff 75 08             	pushl  0x8(%ebp)
  10029e:	e8 44 13 00 00       	call   1015e7 <cons_putc>
  1002a3:	83 c4 10             	add    $0x10,%esp
}
  1002a6:	90                   	nop
  1002a7:	c9                   	leave  
  1002a8:	c3                   	ret    

001002a9 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a9:	55                   	push   %ebp
  1002aa:	89 e5                	mov    %esp,%ebp
  1002ac:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b6:	eb 14                	jmp    1002cc <cputs+0x23>
        cputch(c, &cnt);
  1002b8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002bc:	83 ec 08             	sub    $0x8,%esp
  1002bf:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002c2:	52                   	push   %edx
  1002c3:	50                   	push   %eax
  1002c4:	e8 56 ff ff ff       	call   10021f <cputch>
  1002c9:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cf:	8d 50 01             	lea    0x1(%eax),%edx
  1002d2:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d5:	0f b6 00             	movzbl (%eax),%eax
  1002d8:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002db:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002df:	75 d7                	jne    1002b8 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002e1:	83 ec 08             	sub    $0x8,%esp
  1002e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e7:	50                   	push   %eax
  1002e8:	6a 0a                	push   $0xa
  1002ea:	e8 30 ff ff ff       	call   10021f <cputch>
  1002ef:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f5:	c9                   	leave  
  1002f6:	c3                   	ret    

001002f7 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f7:	55                   	push   %ebp
  1002f8:	89 e5                	mov    %esp,%ebp
  1002fa:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fd:	e8 2e 13 00 00       	call   101630 <cons_getc>
  100302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100305:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100309:	74 f2                	je     1002fd <getchar+0x6>
        /* do nothing */;
    return c;
  10030b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030e:	c9                   	leave  
  10030f:	c3                   	ret    

00100310 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100310:	55                   	push   %ebp
  100311:	89 e5                	mov    %esp,%ebp
  100313:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10031a:	74 13                	je     10032f <readline+0x1f>
        cprintf("%s", prompt);
  10031c:	83 ec 08             	sub    $0x8,%esp
  10031f:	ff 75 08             	pushl  0x8(%ebp)
  100322:	68 87 59 10 00       	push   $0x105987
  100327:	e8 40 ff ff ff       	call   10026c <cprintf>
  10032c:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100336:	e8 bc ff ff ff       	call   1002f7 <getchar>
  10033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100342:	79 0a                	jns    10034e <readline+0x3e>
            return NULL;
  100344:	b8 00 00 00 00       	mov    $0x0,%eax
  100349:	e9 82 00 00 00       	jmp    1003d0 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10034e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100352:	7e 2b                	jle    10037f <readline+0x6f>
  100354:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10035b:	7f 22                	jg     10037f <readline+0x6f>
            cputchar(c);
  10035d:	83 ec 0c             	sub    $0xc,%esp
  100360:	ff 75 f0             	pushl  -0x10(%ebp)
  100363:	e8 2a ff ff ff       	call   100292 <cputchar>
  100368:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10036b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10036e:	8d 50 01             	lea    0x1(%eax),%edx
  100371:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100374:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100377:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10037d:	eb 4c                	jmp    1003cb <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037f:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100383:	75 1a                	jne    10039f <readline+0x8f>
  100385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100389:	7e 14                	jle    10039f <readline+0x8f>
            cputchar(c);
  10038b:	83 ec 0c             	sub    $0xc,%esp
  10038e:	ff 75 f0             	pushl  -0x10(%ebp)
  100391:	e8 fc fe ff ff       	call   100292 <cputchar>
  100396:	83 c4 10             	add    $0x10,%esp
            i --;
  100399:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10039d:	eb 2c                	jmp    1003cb <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003a3:	74 06                	je     1003ab <readline+0x9b>
  1003a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a9:	75 8b                	jne    100336 <readline+0x26>
            cputchar(c);
  1003ab:	83 ec 0c             	sub    $0xc,%esp
  1003ae:	ff 75 f0             	pushl  -0x10(%ebp)
  1003b1:	e8 dc fe ff ff       	call   100292 <cputchar>
  1003b6:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003bc:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003c1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003c4:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003c9:	eb 05                	jmp    1003d0 <readline+0xc0>
        }
    }
  1003cb:	e9 66 ff ff ff       	jmp    100336 <readline+0x26>
}
  1003d0:	c9                   	leave  
  1003d1:	c3                   	ret    

001003d2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003d2:	55                   	push   %ebp
  1003d3:	89 e5                	mov    %esp,%ebp
  1003d5:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d8:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003dd:	85 c0                	test   %eax,%eax
  1003df:	75 4a                	jne    10042b <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003e1:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003e8:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003eb:	8d 45 14             	lea    0x14(%ebp),%eax
  1003ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003f1:	83 ec 04             	sub    $0x4,%esp
  1003f4:	ff 75 0c             	pushl  0xc(%ebp)
  1003f7:	ff 75 08             	pushl  0x8(%ebp)
  1003fa:	68 8a 59 10 00       	push   $0x10598a
  1003ff:	e8 68 fe ff ff       	call   10026c <cprintf>
  100404:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10040a:	83 ec 08             	sub    $0x8,%esp
  10040d:	50                   	push   %eax
  10040e:	ff 75 10             	pushl  0x10(%ebp)
  100411:	e8 2d fe ff ff       	call   100243 <vcprintf>
  100416:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100419:	83 ec 0c             	sub    $0xc,%esp
  10041c:	68 a6 59 10 00       	push   $0x1059a6
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
  100426:	83 c4 10             	add    $0x10,%esp
  100429:	eb 01                	jmp    10042c <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10042b:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  10042c:	e8 3b 14 00 00       	call   10186c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100431:	83 ec 0c             	sub    $0xc,%esp
  100434:	6a 00                	push   $0x0
  100436:	e8 36 08 00 00       	call   100c71 <kmonitor>
  10043b:	83 c4 10             	add    $0x10,%esp
    }
  10043e:	eb f1                	jmp    100431 <__panic+0x5f>

00100440 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100440:	55                   	push   %ebp
  100441:	89 e5                	mov    %esp,%ebp
  100443:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100446:	8d 45 14             	lea    0x14(%ebp),%eax
  100449:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044c:	83 ec 04             	sub    $0x4,%esp
  10044f:	ff 75 0c             	pushl  0xc(%ebp)
  100452:	ff 75 08             	pushl  0x8(%ebp)
  100455:	68 a8 59 10 00       	push   $0x1059a8
  10045a:	e8 0d fe ff ff       	call   10026c <cprintf>
  10045f:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100465:	83 ec 08             	sub    $0x8,%esp
  100468:	50                   	push   %eax
  100469:	ff 75 10             	pushl  0x10(%ebp)
  10046c:	e8 d2 fd ff ff       	call   100243 <vcprintf>
  100471:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100474:	83 ec 0c             	sub    $0xc,%esp
  100477:	68 a6 59 10 00       	push   $0x1059a6
  10047c:	e8 eb fd ff ff       	call   10026c <cprintf>
  100481:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100484:	90                   	nop
  100485:	c9                   	leave  
  100486:	c3                   	ret    

00100487 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100487:	55                   	push   %ebp
  100488:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048a:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  10048f:	5d                   	pop    %ebp
  100490:	c3                   	ret    

00100491 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100491:	55                   	push   %ebp
  100492:	89 e5                	mov    %esp,%ebp
  100494:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100497:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049a:	8b 00                	mov    (%eax),%eax
  10049c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049f:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a2:	8b 00                	mov    (%eax),%eax
  1004a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004ae:	e9 d2 00 00 00       	jmp    100585 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b9:	01 d0                	add    %edx,%eax
  1004bb:	89 c2                	mov    %eax,%edx
  1004bd:	c1 ea 1f             	shr    $0x1f,%edx
  1004c0:	01 d0                	add    %edx,%eax
  1004c2:	d1 f8                	sar    %eax
  1004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004cd:	eb 04                	jmp    1004d3 <stab_binsearch+0x42>
            m --;
  1004cf:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x69>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f8:	75 d5                	jne    1004cf <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 0b                	jge    10050d <stab_binsearch+0x7c>
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	83 c0 01             	add    $0x1,%eax
  100508:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10050b:	eb 78                	jmp    100585 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10050d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100514:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100517:	89 d0                	mov    %edx,%eax
  100519:	01 c0                	add    %eax,%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	c1 e0 02             	shl    $0x2,%eax
  100520:	89 c2                	mov    %eax,%edx
  100522:	8b 45 08             	mov    0x8(%ebp),%eax
  100525:	01 d0                	add    %edx,%eax
  100527:	8b 40 08             	mov    0x8(%eax),%eax
  10052a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052d:	73 13                	jae    100542 <stab_binsearch+0xb1>
            *region_left = m;
  10052f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100535:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053a:	83 c0 01             	add    $0x1,%eax
  10053d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100540:	eb 43                	jmp    100585 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100545:	89 d0                	mov    %edx,%eax
  100547:	01 c0                	add    %eax,%eax
  100549:	01 d0                	add    %edx,%eax
  10054b:	c1 e0 02             	shl    $0x2,%eax
  10054e:	89 c2                	mov    %eax,%edx
  100550:	8b 45 08             	mov    0x8(%ebp),%eax
  100553:	01 d0                	add    %edx,%eax
  100555:	8b 40 08             	mov    0x8(%eax),%eax
  100558:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055b:	76 16                	jbe    100573 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10055d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100560:	8d 50 ff             	lea    -0x1(%eax),%edx
  100563:	8b 45 10             	mov    0x10(%ebp),%eax
  100566:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056b:	83 e8 01             	sub    $0x1,%eax
  10056e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100571:	eb 12                	jmp    100585 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100573:	8b 45 0c             	mov    0xc(%ebp),%eax
  100576:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100579:	89 10                	mov    %edx,(%eax)
            l = m;
  10057b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100581:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100585:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100588:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10058b:	0f 8e 22 ff ff ff    	jle    1004b3 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100595:	75 0f                	jne    1005a6 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100597:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059a:	8b 00                	mov    (%eax),%eax
  10059c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005a4:	eb 3f                	jmp    1005e5 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a9:	8b 00                	mov    (%eax),%eax
  1005ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005ae:	eb 04                	jmp    1005b4 <stab_binsearch+0x123>
  1005b0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b7:	8b 00                	mov    (%eax),%eax
  1005b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005bc:	7d 1f                	jge    1005dd <stab_binsearch+0x14c>
  1005be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c1:	89 d0                	mov    %edx,%eax
  1005c3:	01 c0                	add    %eax,%eax
  1005c5:	01 d0                	add    %edx,%eax
  1005c7:	c1 e0 02             	shl    $0x2,%eax
  1005ca:	89 c2                	mov    %eax,%edx
  1005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cf:	01 d0                	add    %edx,%eax
  1005d1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d5:	0f b6 c0             	movzbl %al,%eax
  1005d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005db:	75 d3                	jne    1005b0 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e3:	89 10                	mov    %edx,(%eax)
    }
}
  1005e5:	90                   	nop
  1005e6:	c9                   	leave  
  1005e7:	c3                   	ret    

001005e8 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e8:	55                   	push   %ebp
  1005e9:	89 e5                	mov    %esp,%ebp
  1005eb:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f1:	c7 00 c8 59 10 00    	movl   $0x1059c8,(%eax)
    info->eip_line = 0;
  1005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100601:	8b 45 0c             	mov    0xc(%ebp),%eax
  100604:	c7 40 08 c8 59 10 00 	movl   $0x1059c8,0x8(%eax)
    info->eip_fn_namelen = 9;
  10060b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060e:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100615:	8b 45 0c             	mov    0xc(%ebp),%eax
  100618:	8b 55 08             	mov    0x8(%ebp),%edx
  10061b:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10061e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100621:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100628:	c7 45 f4 f0 6b 10 00 	movl   $0x106bf0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062f:	c7 45 f0 ec 17 11 00 	movl   $0x1117ec,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100636:	c7 45 ec ed 17 11 00 	movl   $0x1117ed,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10063d:	c7 45 e8 71 42 11 00 	movl   $0x114271,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10064a:	76 0d                	jbe    100659 <debuginfo_eip+0x71>
  10064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064f:	83 e8 01             	sub    $0x1,%eax
  100652:	0f b6 00             	movzbl (%eax),%eax
  100655:	84 c0                	test   %al,%al
  100657:	74 0a                	je     100663 <debuginfo_eip+0x7b>
        return -1;
  100659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10065e:	e9 91 02 00 00       	jmp    1008f4 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10066a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10066d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100670:	29 c2                	sub    %eax,%edx
  100672:	89 d0                	mov    %edx,%eax
  100674:	c1 f8 02             	sar    $0x2,%eax
  100677:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10067d:	83 e8 01             	sub    $0x1,%eax
  100680:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100683:	ff 75 08             	pushl  0x8(%ebp)
  100686:	6a 64                	push   $0x64
  100688:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10068b:	50                   	push   %eax
  10068c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068f:	50                   	push   %eax
  100690:	ff 75 f4             	pushl  -0xc(%ebp)
  100693:	e8 f9 fd ff ff       	call   100491 <stab_binsearch>
  100698:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10069b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069e:	85 c0                	test   %eax,%eax
  1006a0:	75 0a                	jne    1006ac <debuginfo_eip+0xc4>
        return -1;
  1006a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a7:	e9 48 02 00 00       	jmp    1008f4 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b8:	ff 75 08             	pushl  0x8(%ebp)
  1006bb:	6a 24                	push   $0x24
  1006bd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006c0:	50                   	push   %eax
  1006c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c4:	50                   	push   %eax
  1006c5:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c8:	e8 c4 fd ff ff       	call   100491 <stab_binsearch>
  1006cd:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d6:	39 c2                	cmp    %eax,%edx
  1006d8:	7f 7c                	jg     100756 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006dd:	89 c2                	mov    %eax,%edx
  1006df:	89 d0                	mov    %edx,%eax
  1006e1:	01 c0                	add    %eax,%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	c1 e0 02             	shl    $0x2,%eax
  1006e8:	89 c2                	mov    %eax,%edx
  1006ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ed:	01 d0                	add    %edx,%eax
  1006ef:	8b 00                	mov    (%eax),%eax
  1006f1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f7:	29 d1                	sub    %edx,%ecx
  1006f9:	89 ca                	mov    %ecx,%edx
  1006fb:	39 d0                	cmp    %edx,%eax
  1006fd:	73 22                	jae    100721 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100702:	89 c2                	mov    %eax,%edx
  100704:	89 d0                	mov    %edx,%eax
  100706:	01 c0                	add    %eax,%eax
  100708:	01 d0                	add    %edx,%eax
  10070a:	c1 e0 02             	shl    $0x2,%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100712:	01 d0                	add    %edx,%eax
  100714:	8b 10                	mov    (%eax),%edx
  100716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100719:	01 c2                	add    %eax,%edx
  10071b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071e:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100724:	89 c2                	mov    %eax,%edx
  100726:	89 d0                	mov    %edx,%eax
  100728:	01 c0                	add    %eax,%eax
  10072a:	01 d0                	add    %edx,%eax
  10072c:	c1 e0 02             	shl    $0x2,%eax
  10072f:	89 c2                	mov    %eax,%edx
  100731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	8b 50 08             	mov    0x8(%eax),%edx
  100739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073c:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100742:	8b 40 10             	mov    0x10(%eax),%eax
  100745:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100748:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10074e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100751:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100754:	eb 15                	jmp    10076b <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	8b 55 08             	mov    0x8(%ebp),%edx
  10075c:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100765:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100768:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076e:	8b 40 08             	mov    0x8(%eax),%eax
  100771:	83 ec 08             	sub    $0x8,%esp
  100774:	6a 3a                	push   $0x3a
  100776:	50                   	push   %eax
  100777:	e8 2d 48 00 00       	call   104fa9 <strfind>
  10077c:	83 c4 10             	add    $0x10,%esp
  10077f:	89 c2                	mov    %eax,%edx
  100781:	8b 45 0c             	mov    0xc(%ebp),%eax
  100784:	8b 40 08             	mov    0x8(%eax),%eax
  100787:	29 c2                	sub    %eax,%edx
  100789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078f:	83 ec 0c             	sub    $0xc,%esp
  100792:	ff 75 08             	pushl  0x8(%ebp)
  100795:	6a 44                	push   $0x44
  100797:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10079a:	50                   	push   %eax
  10079b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10079e:	50                   	push   %eax
  10079f:	ff 75 f4             	pushl  -0xc(%ebp)
  1007a2:	e8 ea fc ff ff       	call   100491 <stab_binsearch>
  1007a7:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b0:	39 c2                	cmp    %eax,%edx
  1007b2:	7f 24                	jg     1007d8 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	89 d0                	mov    %edx,%eax
  1007bb:	01 c0                	add    %eax,%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	c1 e0 02             	shl    $0x2,%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007cd:	0f b7 d0             	movzwl %ax,%edx
  1007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d3:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d6:	eb 13                	jmp    1007eb <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007dd:	e9 12 01 00 00       	jmp    1008f4 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e5:	83 e8 01             	sub    $0x1,%eax
  1007e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7c 56                	jl     10084b <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f8:	89 c2                	mov    %eax,%edx
  1007fa:	89 d0                	mov    %edx,%eax
  1007fc:	01 c0                	add    %eax,%eax
  1007fe:	01 d0                	add    %edx,%eax
  100800:	c1 e0 02             	shl    $0x2,%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080e:	3c 84                	cmp    $0x84,%al
  100810:	74 39                	je     10084b <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100815:	89 c2                	mov    %eax,%edx
  100817:	89 d0                	mov    %edx,%eax
  100819:	01 c0                	add    %eax,%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	c1 e0 02             	shl    $0x2,%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082b:	3c 64                	cmp    $0x64,%al
  10082d:	75 b3                	jne    1007e2 <debuginfo_eip+0x1fa>
  10082f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100832:	89 c2                	mov    %eax,%edx
  100834:	89 d0                	mov    %edx,%eax
  100836:	01 c0                	add    %eax,%eax
  100838:	01 d0                	add    %edx,%eax
  10083a:	c1 e0 02             	shl    $0x2,%eax
  10083d:	89 c2                	mov    %eax,%edx
  10083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100842:	01 d0                	add    %edx,%eax
  100844:	8b 40 08             	mov    0x8(%eax),%eax
  100847:	85 c0                	test   %eax,%eax
  100849:	74 97                	je     1007e2 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10084b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100851:	39 c2                	cmp    %eax,%edx
  100853:	7c 46                	jl     10089b <debuginfo_eip+0x2b3>
  100855:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100858:	89 c2                	mov    %eax,%edx
  10085a:	89 d0                	mov    %edx,%eax
  10085c:	01 c0                	add    %eax,%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	c1 e0 02             	shl    $0x2,%eax
  100863:	89 c2                	mov    %eax,%edx
  100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100868:	01 d0                	add    %edx,%eax
  10086a:	8b 00                	mov    (%eax),%eax
  10086c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100872:	29 d1                	sub    %edx,%ecx
  100874:	89 ca                	mov    %ecx,%edx
  100876:	39 d0                	cmp    %edx,%eax
  100878:	73 21                	jae    10089b <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10087a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087d:	89 c2                	mov    %eax,%edx
  10087f:	89 d0                	mov    %edx,%eax
  100881:	01 c0                	add    %eax,%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	c1 e0 02             	shl    $0x2,%eax
  100888:	89 c2                	mov    %eax,%edx
  10088a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088d:	01 d0                	add    %edx,%eax
  10088f:	8b 10                	mov    (%eax),%edx
  100891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100894:	01 c2                	add    %eax,%edx
  100896:	8b 45 0c             	mov    0xc(%ebp),%eax
  100899:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10089b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008a1:	39 c2                	cmp    %eax,%edx
  1008a3:	7d 4a                	jge    1008ef <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a8:	83 c0 01             	add    $0x1,%eax
  1008ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ae:	eb 18                	jmp    1008c8 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b3:	8b 40 14             	mov    0x14(%eax),%eax
  1008b6:	8d 50 01             	lea    0x1(%eax),%edx
  1008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008bc:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c2:	83 c0 01             	add    $0x1,%eax
  1008c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008ce:	39 c2                	cmp    %eax,%edx
  1008d0:	7d 1d                	jge    1008ef <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d5:	89 c2                	mov    %eax,%edx
  1008d7:	89 d0                	mov    %edx,%eax
  1008d9:	01 c0                	add    %eax,%eax
  1008db:	01 d0                	add    %edx,%eax
  1008dd:	c1 e0 02             	shl    $0x2,%eax
  1008e0:	89 c2                	mov    %eax,%edx
  1008e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e5:	01 d0                	add    %edx,%eax
  1008e7:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008eb:	3c a0                	cmp    $0xa0,%al
  1008ed:	74 c1                	je     1008b0 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008f4:	c9                   	leave  
  1008f5:	c3                   	ret    

001008f6 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f6:	55                   	push   %ebp
  1008f7:	89 e5                	mov    %esp,%ebp
  1008f9:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008fc:	83 ec 0c             	sub    $0xc,%esp
  1008ff:	68 d2 59 10 00       	push   $0x1059d2
  100904:	e8 63 f9 ff ff       	call   10026c <cprintf>
  100909:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10090c:	83 ec 08             	sub    $0x8,%esp
  10090f:	68 2a 00 10 00       	push   $0x10002a
  100914:	68 eb 59 10 00       	push   $0x1059eb
  100919:	e8 4e f9 ff ff       	call   10026c <cprintf>
  10091e:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100921:	83 ec 08             	sub    $0x8,%esp
  100924:	68 cc 58 10 00       	push   $0x1058cc
  100929:	68 03 5a 10 00       	push   $0x105a03
  10092e:	e8 39 f9 ff ff       	call   10026c <cprintf>
  100933:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100936:	83 ec 08             	sub    $0x8,%esp
  100939:	68 36 7a 11 00       	push   $0x117a36
  10093e:	68 1b 5a 10 00       	push   $0x105a1b
  100943:	e8 24 f9 ff ff       	call   10026c <cprintf>
  100948:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10094b:	83 ec 08             	sub    $0x8,%esp
  10094e:	68 68 89 11 00       	push   $0x118968
  100953:	68 33 5a 10 00       	push   $0x105a33
  100958:	e8 0f f9 ff ff       	call   10026c <cprintf>
  10095d:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100960:	b8 68 89 11 00       	mov    $0x118968,%eax
  100965:	05 ff 03 00 00       	add    $0x3ff,%eax
  10096a:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096f:	29 d0                	sub    %edx,%eax
  100971:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100977:	85 c0                	test   %eax,%eax
  100979:	0f 48 c2             	cmovs  %edx,%eax
  10097c:	c1 f8 0a             	sar    $0xa,%eax
  10097f:	83 ec 08             	sub    $0x8,%esp
  100982:	50                   	push   %eax
  100983:	68 4c 5a 10 00       	push   $0x105a4c
  100988:	e8 df f8 ff ff       	call   10026c <cprintf>
  10098d:	83 c4 10             	add    $0x10,%esp
}
  100990:	90                   	nop
  100991:	c9                   	leave  
  100992:	c3                   	ret    

00100993 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100993:	55                   	push   %ebp
  100994:	89 e5                	mov    %esp,%ebp
  100996:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10099c:	83 ec 08             	sub    $0x8,%esp
  10099f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a2:	50                   	push   %eax
  1009a3:	ff 75 08             	pushl  0x8(%ebp)
  1009a6:	e8 3d fc ff ff       	call   1005e8 <debuginfo_eip>
  1009ab:	83 c4 10             	add    $0x10,%esp
  1009ae:	85 c0                	test   %eax,%eax
  1009b0:	74 15                	je     1009c7 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009b2:	83 ec 08             	sub    $0x8,%esp
  1009b5:	ff 75 08             	pushl  0x8(%ebp)
  1009b8:	68 76 5a 10 00       	push   $0x105a76
  1009bd:	e8 aa f8 ff ff       	call   10026c <cprintf>
  1009c2:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c5:	eb 65                	jmp    100a2c <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009ce:	eb 1c                	jmp    1009ec <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d6:	01 d0                	add    %edx,%eax
  1009d8:	0f b6 00             	movzbl (%eax),%eax
  1009db:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009e4:	01 ca                	add    %ecx,%edx
  1009e6:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009f2:	7f dc                	jg     1009d0 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009f4:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fd:	01 d0                	add    %edx,%eax
  1009ff:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a05:	8b 55 08             	mov    0x8(%ebp),%edx
  100a08:	89 d1                	mov    %edx,%ecx
  100a0a:	29 c1                	sub    %eax,%ecx
  100a0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a12:	83 ec 0c             	sub    $0xc,%esp
  100a15:	51                   	push   %ecx
  100a16:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1c:	51                   	push   %ecx
  100a1d:	52                   	push   %edx
  100a1e:	50                   	push   %eax
  100a1f:	68 92 5a 10 00       	push   $0x105a92
  100a24:	e8 43 f8 ff ff       	call   10026c <cprintf>
  100a29:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a2c:	90                   	nop
  100a2d:	c9                   	leave  
  100a2e:	c3                   	ret    

00100a2f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2f:	55                   	push   %ebp
  100a30:	89 e5                	mov    %esp,%ebp
  100a32:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a35:	8b 45 04             	mov    0x4(%ebp),%eax
  100a38:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a3e:	c9                   	leave  
  100a3f:	c3                   	ret    

00100a40 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a40:	55                   	push   %ebp
  100a41:	89 e5                	mov    %esp,%ebp
  100a43:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a46:	89 e8                	mov    %ebp,%eax
  100a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp(), eip = read_eip();
  100a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a51:	e8 d9 ff ff ff       	call   100a2f <read_eip>
  100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a59:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a60:	e9 8d 00 00 00       	jmp    100af2 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a65:	83 ec 04             	sub    $0x4,%esp
  100a68:	ff 75 f0             	pushl  -0x10(%ebp)
  100a6b:	ff 75 f4             	pushl  -0xc(%ebp)
  100a6e:	68 a4 5a 10 00       	push   $0x105aa4
  100a73:	e8 f4 f7 ff ff       	call   10026c <cprintf>
  100a78:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
  100a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7e:	83 c0 08             	add    $0x8,%eax
  100a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a84:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a8b:	eb 26                	jmp    100ab3 <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
  100a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a9a:	01 d0                	add    %edx,%eax
  100a9c:	8b 00                	mov    (%eax),%eax
  100a9e:	83 ec 08             	sub    $0x8,%esp
  100aa1:	50                   	push   %eax
  100aa2:	68 c0 5a 10 00       	push   $0x105ac0
  100aa7:	e8 c0 f7 ff ff       	call   10026c <cprintf>
  100aac:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100aaf:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100ab3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ab7:	7e d4                	jle    100a8d <print_stackframe+0x4d>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100ab9:	83 ec 0c             	sub    $0xc,%esp
  100abc:	68 c8 5a 10 00       	push   $0x105ac8
  100ac1:	e8 a6 f7 ff ff       	call   10026c <cprintf>
  100ac6:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
  100ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100acc:	83 e8 01             	sub    $0x1,%eax
  100acf:	83 ec 0c             	sub    $0xc,%esp
  100ad2:	50                   	push   %eax
  100ad3:	e8 bb fe ff ff       	call   100993 <print_debuginfo>
  100ad8:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
  100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ade:	83 c0 04             	add    $0x4,%eax
  100ae1:	8b 00                	mov    (%eax),%eax
  100ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae9:	8b 00                	mov    (%eax),%eax
  100aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aee:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af6:	74 0a                	je     100b02 <print_stackframe+0xc2>
  100af8:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100afc:	0f 8e 63 ff ff ff    	jle    100a65 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100b02:	90                   	nop
  100b03:	c9                   	leave  
  100b04:	c3                   	ret    

00100b05 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b05:	55                   	push   %ebp
  100b06:	89 e5                	mov    %esp,%ebp
  100b08:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b12:	eb 0c                	jmp    100b20 <parse+0x1b>
            *buf ++ = '\0';
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	8d 50 01             	lea    0x1(%eax),%edx
  100b1a:	89 55 08             	mov    %edx,0x8(%ebp)
  100b1d:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b20:	8b 45 08             	mov    0x8(%ebp),%eax
  100b23:	0f b6 00             	movzbl (%eax),%eax
  100b26:	84 c0                	test   %al,%al
  100b28:	74 1e                	je     100b48 <parse+0x43>
  100b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2d:	0f b6 00             	movzbl (%eax),%eax
  100b30:	0f be c0             	movsbl %al,%eax
  100b33:	83 ec 08             	sub    $0x8,%esp
  100b36:	50                   	push   %eax
  100b37:	68 4c 5b 10 00       	push   $0x105b4c
  100b3c:	e8 35 44 00 00       	call   104f76 <strchr>
  100b41:	83 c4 10             	add    $0x10,%esp
  100b44:	85 c0                	test   %eax,%eax
  100b46:	75 cc                	jne    100b14 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b48:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4b:	0f b6 00             	movzbl (%eax),%eax
  100b4e:	84 c0                	test   %al,%al
  100b50:	74 69                	je     100bbb <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b52:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b56:	75 12                	jne    100b6a <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b58:	83 ec 08             	sub    $0x8,%esp
  100b5b:	6a 10                	push   $0x10
  100b5d:	68 51 5b 10 00       	push   $0x105b51
  100b62:	e8 05 f7 ff ff       	call   10026c <cprintf>
  100b67:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6d:	8d 50 01             	lea    0x1(%eax),%edx
  100b70:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b7d:	01 c2                	add    %eax,%edx
  100b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b82:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b84:	eb 04                	jmp    100b8a <parse+0x85>
            buf ++;
  100b86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8d:	0f b6 00             	movzbl (%eax),%eax
  100b90:	84 c0                	test   %al,%al
  100b92:	0f 84 7a ff ff ff    	je     100b12 <parse+0xd>
  100b98:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9b:	0f b6 00             	movzbl (%eax),%eax
  100b9e:	0f be c0             	movsbl %al,%eax
  100ba1:	83 ec 08             	sub    $0x8,%esp
  100ba4:	50                   	push   %eax
  100ba5:	68 4c 5b 10 00       	push   $0x105b4c
  100baa:	e8 c7 43 00 00       	call   104f76 <strchr>
  100baf:	83 c4 10             	add    $0x10,%esp
  100bb2:	85 c0                	test   %eax,%eax
  100bb4:	74 d0                	je     100b86 <parse+0x81>
            buf ++;
        }
    }
  100bb6:	e9 57 ff ff ff       	jmp    100b12 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bbb:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bbf:	c9                   	leave  
  100bc0:	c3                   	ret    

00100bc1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bc1:	55                   	push   %ebp
  100bc2:	89 e5                	mov    %esp,%ebp
  100bc4:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bc7:	83 ec 08             	sub    $0x8,%esp
  100bca:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bcd:	50                   	push   %eax
  100bce:	ff 75 08             	pushl  0x8(%ebp)
  100bd1:	e8 2f ff ff ff       	call   100b05 <parse>
  100bd6:	83 c4 10             	add    $0x10,%esp
  100bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100be0:	75 0a                	jne    100bec <runcmd+0x2b>
        return 0;
  100be2:	b8 00 00 00 00       	mov    $0x0,%eax
  100be7:	e9 83 00 00 00       	jmp    100c6f <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf3:	eb 59                	jmp    100c4e <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bf5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfb:	89 d0                	mov    %edx,%eax
  100bfd:	01 c0                	add    %eax,%eax
  100bff:	01 d0                	add    %edx,%eax
  100c01:	c1 e0 02             	shl    $0x2,%eax
  100c04:	05 20 70 11 00       	add    $0x117020,%eax
  100c09:	8b 00                	mov    (%eax),%eax
  100c0b:	83 ec 08             	sub    $0x8,%esp
  100c0e:	51                   	push   %ecx
  100c0f:	50                   	push   %eax
  100c10:	e8 c1 42 00 00       	call   104ed6 <strcmp>
  100c15:	83 c4 10             	add    $0x10,%esp
  100c18:	85 c0                	test   %eax,%eax
  100c1a:	75 2e                	jne    100c4a <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1f:	89 d0                	mov    %edx,%eax
  100c21:	01 c0                	add    %eax,%eax
  100c23:	01 d0                	add    %edx,%eax
  100c25:	c1 e0 02             	shl    $0x2,%eax
  100c28:	05 28 70 11 00       	add    $0x117028,%eax
  100c2d:	8b 10                	mov    (%eax),%edx
  100c2f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c32:	83 c0 04             	add    $0x4,%eax
  100c35:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c38:	83 e9 01             	sub    $0x1,%ecx
  100c3b:	83 ec 04             	sub    $0x4,%esp
  100c3e:	ff 75 0c             	pushl  0xc(%ebp)
  100c41:	50                   	push   %eax
  100c42:	51                   	push   %ecx
  100c43:	ff d2                	call   *%edx
  100c45:	83 c4 10             	add    $0x10,%esp
  100c48:	eb 25                	jmp    100c6f <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c51:	83 f8 02             	cmp    $0x2,%eax
  100c54:	76 9f                	jbe    100bf5 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c56:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c59:	83 ec 08             	sub    $0x8,%esp
  100c5c:	50                   	push   %eax
  100c5d:	68 6f 5b 10 00       	push   $0x105b6f
  100c62:	e8 05 f6 ff ff       	call   10026c <cprintf>
  100c67:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6f:	c9                   	leave  
  100c70:	c3                   	ret    

00100c71 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c71:	55                   	push   %ebp
  100c72:	89 e5                	mov    %esp,%ebp
  100c74:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c77:	83 ec 0c             	sub    $0xc,%esp
  100c7a:	68 88 5b 10 00       	push   $0x105b88
  100c7f:	e8 e8 f5 ff ff       	call   10026c <cprintf>
  100c84:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c87:	83 ec 0c             	sub    $0xc,%esp
  100c8a:	68 b0 5b 10 00       	push   $0x105bb0
  100c8f:	e8 d8 f5 ff ff       	call   10026c <cprintf>
  100c94:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c9b:	74 0e                	je     100cab <kmonitor+0x3a>
        print_trapframe(tf);
  100c9d:	83 ec 0c             	sub    $0xc,%esp
  100ca0:	ff 75 08             	pushl  0x8(%ebp)
  100ca3:	e8 c0 0d 00 00       	call   101a68 <print_trapframe>
  100ca8:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cab:	83 ec 0c             	sub    $0xc,%esp
  100cae:	68 d5 5b 10 00       	push   $0x105bd5
  100cb3:	e8 58 f6 ff ff       	call   100310 <readline>
  100cb8:	83 c4 10             	add    $0x10,%esp
  100cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cc2:	74 e7                	je     100cab <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cc4:	83 ec 08             	sub    $0x8,%esp
  100cc7:	ff 75 08             	pushl  0x8(%ebp)
  100cca:	ff 75 f4             	pushl  -0xc(%ebp)
  100ccd:	e8 ef fe ff ff       	call   100bc1 <runcmd>
  100cd2:	83 c4 10             	add    $0x10,%esp
  100cd5:	85 c0                	test   %eax,%eax
  100cd7:	78 02                	js     100cdb <kmonitor+0x6a>
                break;
            }
        }
    }
  100cd9:	eb d0                	jmp    100cab <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cdb:	90                   	nop
            }
        }
    }
}
  100cdc:	90                   	nop
  100cdd:	c9                   	leave  
  100cde:	c3                   	ret    

00100cdf <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cdf:	55                   	push   %ebp
  100ce0:	89 e5                	mov    %esp,%ebp
  100ce2:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cec:	eb 3c                	jmp    100d2a <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cf1:	89 d0                	mov    %edx,%eax
  100cf3:	01 c0                	add    %eax,%eax
  100cf5:	01 d0                	add    %edx,%eax
  100cf7:	c1 e0 02             	shl    $0x2,%eax
  100cfa:	05 24 70 11 00       	add    $0x117024,%eax
  100cff:	8b 08                	mov    (%eax),%ecx
  100d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d04:	89 d0                	mov    %edx,%eax
  100d06:	01 c0                	add    %eax,%eax
  100d08:	01 d0                	add    %edx,%eax
  100d0a:	c1 e0 02             	shl    $0x2,%eax
  100d0d:	05 20 70 11 00       	add    $0x117020,%eax
  100d12:	8b 00                	mov    (%eax),%eax
  100d14:	83 ec 04             	sub    $0x4,%esp
  100d17:	51                   	push   %ecx
  100d18:	50                   	push   %eax
  100d19:	68 d9 5b 10 00       	push   $0x105bd9
  100d1e:	e8 49 f5 ff ff       	call   10026c <cprintf>
  100d23:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d26:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2d:	83 f8 02             	cmp    $0x2,%eax
  100d30:	76 bc                	jbe    100cee <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d37:	c9                   	leave  
  100d38:	c3                   	ret    

00100d39 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d39:	55                   	push   %ebp
  100d3a:	89 e5                	mov    %esp,%ebp
  100d3c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d3f:	e8 b2 fb ff ff       	call   1008f6 <print_kerninfo>
    return 0;
  100d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d49:	c9                   	leave  
  100d4a:	c3                   	ret    

00100d4b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d4b:	55                   	push   %ebp
  100d4c:	89 e5                	mov    %esp,%ebp
  100d4e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d51:	e8 ea fc ff ff       	call   100a40 <print_stackframe>
    return 0;
  100d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5b:	c9                   	leave  
  100d5c:	c3                   	ret    

00100d5d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
  100d60:	83 ec 18             	sub    $0x18,%esp
  100d63:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d69:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d6d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d71:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d75:	ee                   	out    %al,(%dx)
  100d76:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d7c:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d80:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d84:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
  100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8f:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d9c:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100da3:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da6:	83 ec 0c             	sub    $0xc,%esp
  100da9:	68 e2 5b 10 00       	push   $0x105be2
  100dae:	e8 b9 f4 ff ff       	call   10026c <cprintf>
  100db3:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100db6:	83 ec 0c             	sub    $0xc,%esp
  100db9:	6a 00                	push   $0x0
  100dbb:	e8 3b 09 00 00       	call   1016fb <pic_enable>
  100dc0:	83 c4 10             	add    $0x10,%esp
}
  100dc3:	90                   	nop
  100dc4:	c9                   	leave  
  100dc5:	c3                   	ret    

00100dc6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dc6:	55                   	push   %ebp
  100dc7:	89 e5                	mov    %esp,%ebp
  100dc9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dcc:	9c                   	pushf  
  100dcd:	58                   	pop    %eax
  100dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dd4:	25 00 02 00 00       	and    $0x200,%eax
  100dd9:	85 c0                	test   %eax,%eax
  100ddb:	74 0c                	je     100de9 <__intr_save+0x23>
        intr_disable();
  100ddd:	e8 8a 0a 00 00       	call   10186c <intr_disable>
        return 1;
  100de2:	b8 01 00 00 00       	mov    $0x1,%eax
  100de7:	eb 05                	jmp    100dee <__intr_save+0x28>
    }
    return 0;
  100de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dee:	c9                   	leave  
  100def:	c3                   	ret    

00100df0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100df0:	55                   	push   %ebp
  100df1:	89 e5                	mov    %esp,%ebp
  100df3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100dfa:	74 05                	je     100e01 <__intr_restore+0x11>
        intr_enable();
  100dfc:	e8 64 0a 00 00       	call   101865 <intr_enable>
    }
}
  100e01:	90                   	nop
  100e02:	c9                   	leave  
  100e03:	c3                   	ret    

00100e04 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e04:	55                   	push   %ebp
  100e05:	89 e5                	mov    %esp,%ebp
  100e07:	83 ec 10             	sub    $0x10,%esp
  100e0a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e10:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e14:	89 c2                	mov    %eax,%edx
  100e16:	ec                   	in     (%dx),%al
  100e17:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e1a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e20:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e24:	89 c2                	mov    %eax,%edx
  100e26:	ec                   	in     (%dx),%al
  100e27:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e2a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e30:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e34:	89 c2                	mov    %eax,%edx
  100e36:	ec                   	in     (%dx),%al
  100e37:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e3a:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e40:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e44:	89 c2                	mov    %eax,%edx
  100e46:	ec                   	in     (%dx),%al
  100e47:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e4a:	90                   	nop
  100e4b:	c9                   	leave  
  100e4c:	c3                   	ret    

00100e4d <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e4d:	55                   	push   %ebp
  100e4e:	89 e5                	mov    %esp,%ebp
  100e50:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e53:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5d:	0f b7 00             	movzwl (%eax),%eax
  100e60:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e67:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e6f:	0f b7 00             	movzwl (%eax),%eax
  100e72:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e76:	74 12                	je     100e8a <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e78:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e7f:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e86:	b4 03 
  100e88:	eb 13                	jmp    100e9d <cga_init+0x50>
    } else {
        *cp = was;
  100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e91:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e94:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e9b:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e9d:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ea4:	0f b7 c0             	movzwl %ax,%eax
  100ea7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100eab:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eaf:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100eb3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100eb7:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eb8:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ebf:	83 c0 01             	add    $0x1,%eax
  100ec2:	0f b7 c0             	movzwl %ax,%eax
  100ec5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ec9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ecd:	89 c2                	mov    %eax,%edx
  100ecf:	ec                   	in     (%dx),%al
  100ed0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ed3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ed7:	0f b6 c0             	movzbl %al,%eax
  100eda:	c1 e0 08             	shl    $0x8,%eax
  100edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ee0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee7:	0f b7 c0             	movzwl %ax,%eax
  100eea:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100eee:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100ef6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100efa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100efb:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f02:	83 c0 01             	add    $0x1,%eax
  100f05:	0f b7 c0             	movzwl %ax,%eax
  100f08:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f0c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f10:	89 c2                	mov    %eax,%edx
  100f12:	ec                   	in     (%dx),%al
  100f13:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f16:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1a:	0f b6 c0             	movzbl %al,%eax
  100f1d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f23:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f2b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f31:	90                   	nop
  100f32:	c9                   	leave  
  100f33:	c3                   	ret    

00100f34 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f34:	55                   	push   %ebp
  100f35:	89 e5                	mov    %esp,%ebp
  100f37:	83 ec 28             	sub    $0x28,%esp
  100f3a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f40:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f44:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f48:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
  100f4d:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f53:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f57:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f5b:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
  100f60:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f66:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f6a:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f6e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f72:	ee                   	out    %al,(%dx)
  100f73:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f79:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f7d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f81:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f85:	ee                   	out    %al,(%dx)
  100f86:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f8c:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f90:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f94:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f98:	ee                   	out    %al,(%dx)
  100f99:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f9f:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100fa3:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100fa7:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100fab:	ee                   	out    %al,(%dx)
  100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb2:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fb6:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
  100fbf:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fc5:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fc9:	89 c2                	mov    %eax,%edx
  100fcb:	ec                   	in     (%dx),%al
  100fcc:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fcf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fd3:	3c ff                	cmp    $0xff,%al
  100fd5:	0f 95 c0             	setne  %al
  100fd8:	0f b6 c0             	movzbl %al,%eax
  100fdb:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fe0:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100ff0:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100ff6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100ffa:	89 c2                	mov    %eax,%edx
  100ffc:	ec                   	in     (%dx),%al
  100ffd:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101000:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101005:	85 c0                	test   %eax,%eax
  101007:	74 0d                	je     101016 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  101009:	83 ec 0c             	sub    $0xc,%esp
  10100c:	6a 04                	push   $0x4
  10100e:	e8 e8 06 00 00       	call   1016fb <pic_enable>
  101013:	83 c4 10             	add    $0x10,%esp
    }
}
  101016:	90                   	nop
  101017:	c9                   	leave  
  101018:	c3                   	ret    

00101019 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101019:	55                   	push   %ebp
  10101a:	89 e5                	mov    %esp,%ebp
  10101c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101026:	eb 09                	jmp    101031 <lpt_putc_sub+0x18>
        delay();
  101028:	e8 d7 fd ff ff       	call   100e04 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10102d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101031:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  101037:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10103b:	89 c2                	mov    %eax,%edx
  10103d:	ec                   	in     (%dx),%al
  10103e:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  101041:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101045:	84 c0                	test   %al,%al
  101047:	78 09                	js     101052 <lpt_putc_sub+0x39>
  101049:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101050:	7e d6                	jle    101028 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101052:	8b 45 08             	mov    0x8(%ebp),%eax
  101055:	0f b6 c0             	movzbl %al,%eax
  101058:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  10105e:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101061:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  101065:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101069:	ee                   	out    %al,(%dx)
  10106a:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101070:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101074:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101078:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10107c:	ee                   	out    %al,(%dx)
  10107d:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101083:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101087:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10108b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10108f:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101090:	90                   	nop
  101091:	c9                   	leave  
  101092:	c3                   	ret    

00101093 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101093:	55                   	push   %ebp
  101094:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101096:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10109a:	74 0d                	je     1010a9 <lpt_putc+0x16>
        lpt_putc_sub(c);
  10109c:	ff 75 08             	pushl  0x8(%ebp)
  10109f:	e8 75 ff ff ff       	call   101019 <lpt_putc_sub>
  1010a4:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010a7:	eb 1e                	jmp    1010c7 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1010a9:	6a 08                	push   $0x8
  1010ab:	e8 69 ff ff ff       	call   101019 <lpt_putc_sub>
  1010b0:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010b3:	6a 20                	push   $0x20
  1010b5:	e8 5f ff ff ff       	call   101019 <lpt_putc_sub>
  1010ba:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010bd:	6a 08                	push   $0x8
  1010bf:	e8 55 ff ff ff       	call   101019 <lpt_putc_sub>
  1010c4:	83 c4 04             	add    $0x4,%esp
    }
}
  1010c7:	90                   	nop
  1010c8:	c9                   	leave  
  1010c9:	c3                   	ret    

001010ca <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010ca:	55                   	push   %ebp
  1010cb:	89 e5                	mov    %esp,%ebp
  1010cd:	53                   	push   %ebx
  1010ce:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d4:	b0 00                	mov    $0x0,%al
  1010d6:	85 c0                	test   %eax,%eax
  1010d8:	75 07                	jne    1010e1 <cga_putc+0x17>
        c |= 0x0700;
  1010da:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e4:	0f b6 c0             	movzbl %al,%eax
  1010e7:	83 f8 0a             	cmp    $0xa,%eax
  1010ea:	74 4e                	je     10113a <cga_putc+0x70>
  1010ec:	83 f8 0d             	cmp    $0xd,%eax
  1010ef:	74 59                	je     10114a <cga_putc+0x80>
  1010f1:	83 f8 08             	cmp    $0x8,%eax
  1010f4:	0f 85 8a 00 00 00    	jne    101184 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010fa:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101101:	66 85 c0             	test   %ax,%ax
  101104:	0f 84 a0 00 00 00    	je     1011aa <cga_putc+0xe0>
            crt_pos --;
  10110a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101111:	83 e8 01             	sub    $0x1,%eax
  101114:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10111a:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10111f:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101126:	0f b7 d2             	movzwl %dx,%edx
  101129:	01 d2                	add    %edx,%edx
  10112b:	01 d0                	add    %edx,%eax
  10112d:	8b 55 08             	mov    0x8(%ebp),%edx
  101130:	b2 00                	mov    $0x0,%dl
  101132:	83 ca 20             	or     $0x20,%edx
  101135:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101138:	eb 70                	jmp    1011aa <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  10113a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101141:	83 c0 50             	add    $0x50,%eax
  101144:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10114a:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101151:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101158:	0f b7 c1             	movzwl %cx,%eax
  10115b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101161:	c1 e8 10             	shr    $0x10,%eax
  101164:	89 c2                	mov    %eax,%edx
  101166:	66 c1 ea 06          	shr    $0x6,%dx
  10116a:	89 d0                	mov    %edx,%eax
  10116c:	c1 e0 02             	shl    $0x2,%eax
  10116f:	01 d0                	add    %edx,%eax
  101171:	c1 e0 04             	shl    $0x4,%eax
  101174:	29 c1                	sub    %eax,%ecx
  101176:	89 ca                	mov    %ecx,%edx
  101178:	89 d8                	mov    %ebx,%eax
  10117a:	29 d0                	sub    %edx,%eax
  10117c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  101182:	eb 27                	jmp    1011ab <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101184:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  10118a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101191:	8d 50 01             	lea    0x1(%eax),%edx
  101194:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  10119b:	0f b7 c0             	movzwl %ax,%eax
  10119e:	01 c0                	add    %eax,%eax
  1011a0:	01 c8                	add    %ecx,%eax
  1011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1011a5:	66 89 10             	mov    %dx,(%eax)
        break;
  1011a8:	eb 01                	jmp    1011ab <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011aa:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ab:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b2:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011b6:	76 59                	jbe    101211 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011b8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011bd:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011c3:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011c8:	83 ec 04             	sub    $0x4,%esp
  1011cb:	68 00 0f 00 00       	push   $0xf00
  1011d0:	52                   	push   %edx
  1011d1:	50                   	push   %eax
  1011d2:	e8 9e 3f 00 00       	call   105175 <memmove>
  1011d7:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011da:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011e1:	eb 15                	jmp    1011f8 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011e3:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011eb:	01 d2                	add    %edx,%edx
  1011ed:	01 d0                	add    %edx,%eax
  1011ef:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011f8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ff:	7e e2                	jle    1011e3 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101201:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101208:	83 e8 50             	sub    $0x50,%eax
  10120b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101211:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101218:	0f b7 c0             	movzwl %ax,%eax
  10121b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10121f:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  101223:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  101227:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10122b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10122c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101233:	66 c1 e8 08          	shr    $0x8,%ax
  101237:	0f b6 c0             	movzbl %al,%eax
  10123a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101241:	83 c2 01             	add    $0x1,%edx
  101244:	0f b7 d2             	movzwl %dx,%edx
  101247:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  10124b:	88 45 e9             	mov    %al,-0x17(%ebp)
  10124e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101252:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101256:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101257:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10125e:	0f b7 c0             	movzwl %ax,%eax
  101261:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101265:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101269:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  10126d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101271:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101272:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101279:	0f b6 c0             	movzbl %al,%eax
  10127c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101283:	83 c2 01             	add    $0x1,%edx
  101286:	0f b7 d2             	movzwl %dx,%edx
  101289:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  10128d:	88 45 eb             	mov    %al,-0x15(%ebp)
  101290:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101294:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
}
  101299:	90                   	nop
  10129a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10129d:	c9                   	leave  
  10129e:	c3                   	ret    

0010129f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10129f:	55                   	push   %ebp
  1012a0:	89 e5                	mov    %esp,%ebp
  1012a2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012ac:	eb 09                	jmp    1012b7 <serial_putc_sub+0x18>
        delay();
  1012ae:	e8 51 fb ff ff       	call   100e04 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012b7:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012bd:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012c1:	89 c2                	mov    %eax,%edx
  1012c3:	ec                   	in     (%dx),%al
  1012c4:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012c7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012cb:	0f b6 c0             	movzbl %al,%eax
  1012ce:	83 e0 20             	and    $0x20,%eax
  1012d1:	85 c0                	test   %eax,%eax
  1012d3:	75 09                	jne    1012de <serial_putc_sub+0x3f>
  1012d5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012dc:	7e d0                	jle    1012ae <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012de:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e1:	0f b6 c0             	movzbl %al,%eax
  1012e4:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012ea:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012ed:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012f1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012f5:	ee                   	out    %al,(%dx)
}
  1012f6:	90                   	nop
  1012f7:	c9                   	leave  
  1012f8:	c3                   	ret    

001012f9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012f9:	55                   	push   %ebp
  1012fa:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012fc:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101300:	74 0d                	je     10130f <serial_putc+0x16>
        serial_putc_sub(c);
  101302:	ff 75 08             	pushl  0x8(%ebp)
  101305:	e8 95 ff ff ff       	call   10129f <serial_putc_sub>
  10130a:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10130d:	eb 1e                	jmp    10132d <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  10130f:	6a 08                	push   $0x8
  101311:	e8 89 ff ff ff       	call   10129f <serial_putc_sub>
  101316:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101319:	6a 20                	push   $0x20
  10131b:	e8 7f ff ff ff       	call   10129f <serial_putc_sub>
  101320:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  101323:	6a 08                	push   $0x8
  101325:	e8 75 ff ff ff       	call   10129f <serial_putc_sub>
  10132a:	83 c4 04             	add    $0x4,%esp
    }
}
  10132d:	90                   	nop
  10132e:	c9                   	leave  
  10132f:	c3                   	ret    

00101330 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101330:	55                   	push   %ebp
  101331:	89 e5                	mov    %esp,%ebp
  101333:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101336:	eb 33                	jmp    10136b <cons_intr+0x3b>
        if (c != 0) {
  101338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10133c:	74 2d                	je     10136b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10133e:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101343:	8d 50 01             	lea    0x1(%eax),%edx
  101346:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10134c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10134f:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101355:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10135a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10135f:	75 0a                	jne    10136b <cons_intr+0x3b>
                cons.wpos = 0;
  101361:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101368:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10136b:	8b 45 08             	mov    0x8(%ebp),%eax
  10136e:	ff d0                	call   *%eax
  101370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101373:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101377:	75 bf                	jne    101338 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101379:	90                   	nop
  10137a:	c9                   	leave  
  10137b:	c3                   	ret    

0010137c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10137c:	55                   	push   %ebp
  10137d:	89 e5                	mov    %esp,%ebp
  10137f:	83 ec 10             	sub    $0x10,%esp
  101382:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101388:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10138c:	89 c2                	mov    %eax,%edx
  10138e:	ec                   	in     (%dx),%al
  10138f:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101392:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101396:	0f b6 c0             	movzbl %al,%eax
  101399:	83 e0 01             	and    $0x1,%eax
  10139c:	85 c0                	test   %eax,%eax
  10139e:	75 07                	jne    1013a7 <serial_proc_data+0x2b>
        return -1;
  1013a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013a5:	eb 2a                	jmp    1013d1 <serial_proc_data+0x55>
  1013a7:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ad:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b1:	89 c2                	mov    %eax,%edx
  1013b3:	ec                   	in     (%dx),%al
  1013b4:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013b7:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013bb:	0f b6 c0             	movzbl %al,%eax
  1013be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013c1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013c5:	75 07                	jne    1013ce <serial_proc_data+0x52>
        c = '\b';
  1013c7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013d1:	c9                   	leave  
  1013d2:	c3                   	ret    

001013d3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013d3:	55                   	push   %ebp
  1013d4:	89 e5                	mov    %esp,%ebp
  1013d6:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013d9:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013de:	85 c0                	test   %eax,%eax
  1013e0:	74 10                	je     1013f2 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013e2:	83 ec 0c             	sub    $0xc,%esp
  1013e5:	68 7c 13 10 00       	push   $0x10137c
  1013ea:	e8 41 ff ff ff       	call   101330 <cons_intr>
  1013ef:	83 c4 10             	add    $0x10,%esp
    }
}
  1013f2:	90                   	nop
  1013f3:	c9                   	leave  
  1013f4:	c3                   	ret    

001013f5 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013f5:	55                   	push   %ebp
  1013f6:	89 e5                	mov    %esp,%ebp
  1013f8:	83 ec 18             	sub    $0x18,%esp
  1013fb:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101401:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101405:	89 c2                	mov    %eax,%edx
  101407:	ec                   	in     (%dx),%al
  101408:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10140f:	0f b6 c0             	movzbl %al,%eax
  101412:	83 e0 01             	and    $0x1,%eax
  101415:	85 c0                	test   %eax,%eax
  101417:	75 0a                	jne    101423 <kbd_proc_data+0x2e>
        return -1;
  101419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10141e:	e9 5d 01 00 00       	jmp    101580 <kbd_proc_data+0x18b>
  101423:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142d:	89 c2                	mov    %eax,%edx
  10142f:	ec                   	in     (%dx),%al
  101430:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  101433:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  101437:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10143a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10143e:	75 17                	jne    101457 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101440:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101445:	83 c8 40             	or     $0x40,%eax
  101448:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10144d:	b8 00 00 00 00       	mov    $0x0,%eax
  101452:	e9 29 01 00 00       	jmp    101580 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145b:	84 c0                	test   %al,%al
  10145d:	79 47                	jns    1014a6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10145f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101464:	83 e0 40             	and    $0x40,%eax
  101467:	85 c0                	test   %eax,%eax
  101469:	75 09                	jne    101474 <kbd_proc_data+0x7f>
  10146b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146f:	83 e0 7f             	and    $0x7f,%eax
  101472:	eb 04                	jmp    101478 <kbd_proc_data+0x83>
  101474:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101478:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101486:	83 c8 40             	or     $0x40,%eax
  101489:	0f b6 c0             	movzbl %al,%eax
  10148c:	f7 d0                	not    %eax
  10148e:	89 c2                	mov    %eax,%edx
  101490:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101495:	21 d0                	and    %edx,%eax
  101497:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10149c:	b8 00 00 00 00       	mov    $0x0,%eax
  1014a1:	e9 da 00 00 00       	jmp    101580 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1014a6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ab:	83 e0 40             	and    $0x40,%eax
  1014ae:	85 c0                	test   %eax,%eax
  1014b0:	74 11                	je     1014c3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014b2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014b6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bb:	83 e0 bf             	and    $0xffffffbf,%eax
  1014be:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c7:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ce:	0f b6 d0             	movzbl %al,%edx
  1014d1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d6:	09 d0                	or     %edx,%eax
  1014d8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014dd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e1:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014e8:	0f b6 d0             	movzbl %al,%edx
  1014eb:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f0:	31 d0                	xor    %edx,%eax
  1014f2:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014f7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fc:	83 e0 03             	and    $0x3,%eax
  1014ff:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101506:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150a:	01 d0                	add    %edx,%eax
  10150c:	0f b6 00             	movzbl (%eax),%eax
  10150f:	0f b6 c0             	movzbl %al,%eax
  101512:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101515:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151a:	83 e0 08             	and    $0x8,%eax
  10151d:	85 c0                	test   %eax,%eax
  10151f:	74 22                	je     101543 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101521:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101525:	7e 0c                	jle    101533 <kbd_proc_data+0x13e>
  101527:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10152b:	7f 06                	jg     101533 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10152d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101531:	eb 10                	jmp    101543 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101533:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101537:	7e 0a                	jle    101543 <kbd_proc_data+0x14e>
  101539:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10153d:	7f 04                	jg     101543 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10153f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101543:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101548:	f7 d0                	not    %eax
  10154a:	83 e0 06             	and    $0x6,%eax
  10154d:	85 c0                	test   %eax,%eax
  10154f:	75 2c                	jne    10157d <kbd_proc_data+0x188>
  101551:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101558:	75 23                	jne    10157d <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  10155a:	83 ec 0c             	sub    $0xc,%esp
  10155d:	68 fd 5b 10 00       	push   $0x105bfd
  101562:	e8 05 ed ff ff       	call   10026c <cprintf>
  101567:	83 c4 10             	add    $0x10,%esp
  10156a:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101570:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101574:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101578:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10157c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101580:	c9                   	leave  
  101581:	c3                   	ret    

00101582 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101582:	55                   	push   %ebp
  101583:	89 e5                	mov    %esp,%ebp
  101585:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101588:	83 ec 0c             	sub    $0xc,%esp
  10158b:	68 f5 13 10 00       	push   $0x1013f5
  101590:	e8 9b fd ff ff       	call   101330 <cons_intr>
  101595:	83 c4 10             	add    $0x10,%esp
}
  101598:	90                   	nop
  101599:	c9                   	leave  
  10159a:	c3                   	ret    

0010159b <kbd_init>:

static void
kbd_init(void) {
  10159b:	55                   	push   %ebp
  10159c:	89 e5                	mov    %esp,%ebp
  10159e:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  1015a1:	e8 dc ff ff ff       	call   101582 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015a6:	83 ec 0c             	sub    $0xc,%esp
  1015a9:	6a 01                	push   $0x1
  1015ab:	e8 4b 01 00 00       	call   1016fb <pic_enable>
  1015b0:	83 c4 10             	add    $0x10,%esp
}
  1015b3:	90                   	nop
  1015b4:	c9                   	leave  
  1015b5:	c3                   	ret    

001015b6 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015b6:	55                   	push   %ebp
  1015b7:	89 e5                	mov    %esp,%ebp
  1015b9:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015bc:	e8 8c f8 ff ff       	call   100e4d <cga_init>
    serial_init();
  1015c1:	e8 6e f9 ff ff       	call   100f34 <serial_init>
    kbd_init();
  1015c6:	e8 d0 ff ff ff       	call   10159b <kbd_init>
    if (!serial_exists) {
  1015cb:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015d0:	85 c0                	test   %eax,%eax
  1015d2:	75 10                	jne    1015e4 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015d4:	83 ec 0c             	sub    $0xc,%esp
  1015d7:	68 09 5c 10 00       	push   $0x105c09
  1015dc:	e8 8b ec ff ff       	call   10026c <cprintf>
  1015e1:	83 c4 10             	add    $0x10,%esp
    }
}
  1015e4:	90                   	nop
  1015e5:	c9                   	leave  
  1015e6:	c3                   	ret    

001015e7 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015e7:	55                   	push   %ebp
  1015e8:	89 e5                	mov    %esp,%ebp
  1015ea:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015ed:	e8 d4 f7 ff ff       	call   100dc6 <__intr_save>
  1015f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015f5:	83 ec 0c             	sub    $0xc,%esp
  1015f8:	ff 75 08             	pushl  0x8(%ebp)
  1015fb:	e8 93 fa ff ff       	call   101093 <lpt_putc>
  101600:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  101603:	83 ec 0c             	sub    $0xc,%esp
  101606:	ff 75 08             	pushl  0x8(%ebp)
  101609:	e8 bc fa ff ff       	call   1010ca <cga_putc>
  10160e:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  101611:	83 ec 0c             	sub    $0xc,%esp
  101614:	ff 75 08             	pushl  0x8(%ebp)
  101617:	e8 dd fc ff ff       	call   1012f9 <serial_putc>
  10161c:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  10161f:	83 ec 0c             	sub    $0xc,%esp
  101622:	ff 75 f4             	pushl  -0xc(%ebp)
  101625:	e8 c6 f7 ff ff       	call   100df0 <__intr_restore>
  10162a:	83 c4 10             	add    $0x10,%esp
}
  10162d:	90                   	nop
  10162e:	c9                   	leave  
  10162f:	c3                   	ret    

00101630 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10163d:	e8 84 f7 ff ff       	call   100dc6 <__intr_save>
  101642:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101645:	e8 89 fd ff ff       	call   1013d3 <serial_intr>
        kbd_intr();
  10164a:	e8 33 ff ff ff       	call   101582 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10164f:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101655:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165a:	39 c2                	cmp    %eax,%edx
  10165c:	74 31                	je     10168f <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10165e:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101663:	8d 50 01             	lea    0x1(%eax),%edx
  101666:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10166c:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101673:	0f b6 c0             	movzbl %al,%eax
  101676:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101679:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10167e:	3d 00 02 00 00       	cmp    $0x200,%eax
  101683:	75 0a                	jne    10168f <cons_getc+0x5f>
                cons.rpos = 0;
  101685:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10168c:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10168f:	83 ec 0c             	sub    $0xc,%esp
  101692:	ff 75 f0             	pushl  -0x10(%ebp)
  101695:	e8 56 f7 ff ff       	call   100df0 <__intr_restore>
  10169a:	83 c4 10             	add    $0x10,%esp
    return c;
  10169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a0:	c9                   	leave  
  1016a1:	c3                   	ret    

001016a2 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp
  1016a5:	83 ec 14             	sub    $0x14,%esp
  1016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ab:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016af:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016b3:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016b9:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016be:	85 c0                	test   %eax,%eax
  1016c0:	74 36                	je     1016f8 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c6:	0f b6 c0             	movzbl %al,%eax
  1016c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016cf:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016d2:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016d6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016da:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016db:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016df:	66 c1 e8 08          	shr    $0x8,%ax
  1016e3:	0f b6 c0             	movzbl %al,%eax
  1016e6:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016ec:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016ef:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016f3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
    }
}
  1016f8:	90                   	nop
  1016f9:	c9                   	leave  
  1016fa:	c3                   	ret    

001016fb <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016fb:	55                   	push   %ebp
  1016fc:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101701:	ba 01 00 00 00       	mov    $0x1,%edx
  101706:	89 c1                	mov    %eax,%ecx
  101708:	d3 e2                	shl    %cl,%edx
  10170a:	89 d0                	mov    %edx,%eax
  10170c:	f7 d0                	not    %eax
  10170e:	89 c2                	mov    %eax,%edx
  101710:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101717:	21 d0                	and    %edx,%eax
  101719:	0f b7 c0             	movzwl %ax,%eax
  10171c:	50                   	push   %eax
  10171d:	e8 80 ff ff ff       	call   1016a2 <pic_setmask>
  101722:	83 c4 04             	add    $0x4,%esp
}
  101725:	90                   	nop
  101726:	c9                   	leave  
  101727:	c3                   	ret    

00101728 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
  10172b:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  10172e:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101735:	00 00 00 
  101738:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10173e:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  101742:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101746:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10174a:	ee                   	out    %al,(%dx)
  10174b:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101751:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  101755:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101759:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  101764:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  101768:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  10176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  101777:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  10177b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10177f:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  10178a:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  10178e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101792:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  10179d:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1017a1:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1017a5:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017b0:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017b4:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017b8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017c3:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017c7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017cb:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017d6:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017da:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017de:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
  1017e3:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017e9:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017ed:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017f1:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
  1017f6:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017fc:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101800:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  101804:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101808:	ee                   	out    %al,(%dx)
  101809:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10180f:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101813:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101817:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
  10181c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101822:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101826:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10182a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
  10182f:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101835:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  101839:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10183d:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101842:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101849:	66 83 f8 ff          	cmp    $0xffff,%ax
  10184d:	74 13                	je     101862 <pic_init+0x13a>
        pic_setmask(irq_mask);
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	0f b7 c0             	movzwl %ax,%eax
  101859:	50                   	push   %eax
  10185a:	e8 43 fe ff ff       	call   1016a2 <pic_setmask>
  10185f:	83 c4 04             	add    $0x4,%esp
    }
}
  101862:	90                   	nop
  101863:	c9                   	leave  
  101864:	c3                   	ret    

00101865 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101865:	55                   	push   %ebp
  101866:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101868:	fb                   	sti    
    sti();
}
  101869:	90                   	nop
  10186a:	5d                   	pop    %ebp
  10186b:	c3                   	ret    

0010186c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10186c:	55                   	push   %ebp
  10186d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  10186f:	fa                   	cli    
    cli();
}
  101870:	90                   	nop
  101871:	5d                   	pop    %ebp
  101872:	c3                   	ret    

00101873 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101873:	55                   	push   %ebp
  101874:	89 e5                	mov    %esp,%ebp
  101876:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101879:	83 ec 08             	sub    $0x8,%esp
  10187c:	6a 64                	push   $0x64
  10187e:	68 40 5c 10 00       	push   $0x105c40
  101883:	e8 e4 e9 ff ff       	call   10026c <cprintf>
  101888:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188b:	83 ec 0c             	sub    $0xc,%esp
  10188e:	68 4a 5c 10 00       	push   $0x105c4a
  101893:	e8 d4 e9 ff ff       	call   10026c <cprintf>
  101898:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  10189b:	83 ec 04             	sub    $0x4,%esp
  10189e:	68 58 5c 10 00       	push   $0x105c58
  1018a3:	6a 12                	push   $0x12
  1018a5:	68 6e 5c 10 00       	push   $0x105c6e
  1018aa:	e8 23 eb ff ff       	call   1003d2 <__panic>

001018af <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018af:	55                   	push   %ebp
  1018b0:	89 e5                	mov    %esp,%ebp
  1018b2:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018bc:	e9 c3 00 00 00       	jmp    101984 <idt_init+0xd5>
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c4:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018cb:	89 c2                	mov    %eax,%edx
  1018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d0:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018d7:	00 
  1018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018db:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018e2:	00 08 00 
  1018e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e8:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018ef:	00 
  1018f0:	83 e2 e0             	and    $0xffffffe0,%edx
  1018f3:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fd:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101904:	00 
  101905:	83 e2 1f             	and    $0x1f,%edx
  101908:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10190f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101912:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101919:	00 
  10191a:	83 e2 f0             	and    $0xfffffff0,%edx
  10191d:	83 ca 0e             	or     $0xe,%edx
  101920:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192a:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101931:	00 
  101932:	83 e2 ef             	and    $0xffffffef,%edx
  101935:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193f:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101946:	00 
  101947:	83 e2 9f             	and    $0xffffff9f,%edx
  10194a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101951:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101954:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195b:	00 
  10195c:	83 ca 80             	or     $0xffffff80,%edx
  10195f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101966:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101969:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101970:	c1 e8 10             	shr    $0x10,%eax
  101973:	89 c2                	mov    %eax,%edx
  101975:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101978:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10197f:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
        extern uintptr_t __vectors[];
        int i;
        for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101980:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	3d ff 00 00 00       	cmp    $0xff,%eax
  10198c:	0f 86 2f ff ff ff    	jbe    1018c1 <idt_init+0x12>
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
        }
        // set for switch from user to kernel
        SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101992:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101997:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10199d:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019a4:	08 00 
  1019a6:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019ad:	83 e0 e0             	and    $0xffffffe0,%eax
  1019b0:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019b5:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019bc:	83 e0 1f             	and    $0x1f,%eax
  1019bf:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019c4:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019cb:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ce:	83 c8 0e             	or     $0xe,%eax
  1019d1:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d6:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019dd:	83 e0 ef             	and    $0xffffffef,%eax
  1019e0:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e5:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ec:	83 c8 60             	or     $0x60,%eax
  1019ef:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019f4:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019fb:	83 c8 80             	or     $0xffffff80,%eax
  1019fe:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a03:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a08:	c1 e8 10             	shr    $0x10,%eax
  101a0b:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a11:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a1b:	0f 01 18             	lidtl  (%eax)
        // load the IDT
        lidt(&idt_pd);
}
  101a1e:	90                   	nop
  101a1f:	c9                   	leave  
  101a20:	c3                   	ret    

00101a21 <trapname>:

static const char *
trapname(int trapno) {
  101a21:	55                   	push   %ebp
  101a22:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	83 f8 13             	cmp    $0x13,%eax
  101a2a:	77 0c                	ja     101a38 <trapname+0x17>
        return excnames[trapno];
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	8b 04 85 c0 5f 10 00 	mov    0x105fc0(,%eax,4),%eax
  101a36:	eb 18                	jmp    101a50 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a38:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a3c:	7e 0d                	jle    101a4b <trapname+0x2a>
  101a3e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a42:	7f 07                	jg     101a4b <trapname+0x2a>
        return "Hardware Interrupt";
  101a44:	b8 7f 5c 10 00       	mov    $0x105c7f,%eax
  101a49:	eb 05                	jmp    101a50 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a4b:	b8 92 5c 10 00       	mov    $0x105c92,%eax
}
  101a50:	5d                   	pop    %ebp
  101a51:	c3                   	ret    

00101a52 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a52:	55                   	push   %ebp
  101a53:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a5c:	66 83 f8 08          	cmp    $0x8,%ax
  101a60:	0f 94 c0             	sete   %al
  101a63:	0f b6 c0             	movzbl %al,%eax
}
  101a66:	5d                   	pop    %ebp
  101a67:	c3                   	ret    

00101a68 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a68:	55                   	push   %ebp
  101a69:	89 e5                	mov    %esp,%ebp
  101a6b:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a6e:	83 ec 08             	sub    $0x8,%esp
  101a71:	ff 75 08             	pushl  0x8(%ebp)
  101a74:	68 d3 5c 10 00       	push   $0x105cd3
  101a79:	e8 ee e7 ff ff       	call   10026c <cprintf>
  101a7e:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	83 ec 0c             	sub    $0xc,%esp
  101a87:	50                   	push   %eax
  101a88:	e8 b8 01 00 00       	call   101c45 <print_regs>
  101a8d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a90:	8b 45 08             	mov    0x8(%ebp),%eax
  101a93:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a97:	0f b7 c0             	movzwl %ax,%eax
  101a9a:	83 ec 08             	sub    $0x8,%esp
  101a9d:	50                   	push   %eax
  101a9e:	68 e4 5c 10 00       	push   $0x105ce4
  101aa3:	e8 c4 e7 ff ff       	call   10026c <cprintf>
  101aa8:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ab2:	0f b7 c0             	movzwl %ax,%eax
  101ab5:	83 ec 08             	sub    $0x8,%esp
  101ab8:	50                   	push   %eax
  101ab9:	68 f7 5c 10 00       	push   $0x105cf7
  101abe:	e8 a9 e7 ff ff       	call   10026c <cprintf>
  101ac3:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101acd:	0f b7 c0             	movzwl %ax,%eax
  101ad0:	83 ec 08             	sub    $0x8,%esp
  101ad3:	50                   	push   %eax
  101ad4:	68 0a 5d 10 00       	push   $0x105d0a
  101ad9:	e8 8e e7 ff ff       	call   10026c <cprintf>
  101ade:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae8:	0f b7 c0             	movzwl %ax,%eax
  101aeb:	83 ec 08             	sub    $0x8,%esp
  101aee:	50                   	push   %eax
  101aef:	68 1d 5d 10 00       	push   $0x105d1d
  101af4:	e8 73 e7 ff ff       	call   10026c <cprintf>
  101af9:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	8b 40 30             	mov    0x30(%eax),%eax
  101b02:	83 ec 0c             	sub    $0xc,%esp
  101b05:	50                   	push   %eax
  101b06:	e8 16 ff ff ff       	call   101a21 <trapname>
  101b0b:	83 c4 10             	add    $0x10,%esp
  101b0e:	89 c2                	mov    %eax,%edx
  101b10:	8b 45 08             	mov    0x8(%ebp),%eax
  101b13:	8b 40 30             	mov    0x30(%eax),%eax
  101b16:	83 ec 04             	sub    $0x4,%esp
  101b19:	52                   	push   %edx
  101b1a:	50                   	push   %eax
  101b1b:	68 30 5d 10 00       	push   $0x105d30
  101b20:	e8 47 e7 ff ff       	call   10026c <cprintf>
  101b25:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	8b 40 34             	mov    0x34(%eax),%eax
  101b2e:	83 ec 08             	sub    $0x8,%esp
  101b31:	50                   	push   %eax
  101b32:	68 42 5d 10 00       	push   $0x105d42
  101b37:	e8 30 e7 ff ff       	call   10026c <cprintf>
  101b3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	8b 40 38             	mov    0x38(%eax),%eax
  101b45:	83 ec 08             	sub    $0x8,%esp
  101b48:	50                   	push   %eax
  101b49:	68 51 5d 10 00       	push   $0x105d51
  101b4e:	e8 19 e7 ff ff       	call   10026c <cprintf>
  101b53:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b56:	8b 45 08             	mov    0x8(%ebp),%eax
  101b59:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b5d:	0f b7 c0             	movzwl %ax,%eax
  101b60:	83 ec 08             	sub    $0x8,%esp
  101b63:	50                   	push   %eax
  101b64:	68 60 5d 10 00       	push   $0x105d60
  101b69:	e8 fe e6 ff ff       	call   10026c <cprintf>
  101b6e:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b71:	8b 45 08             	mov    0x8(%ebp),%eax
  101b74:	8b 40 40             	mov    0x40(%eax),%eax
  101b77:	83 ec 08             	sub    $0x8,%esp
  101b7a:	50                   	push   %eax
  101b7b:	68 73 5d 10 00       	push   $0x105d73
  101b80:	e8 e7 e6 ff ff       	call   10026c <cprintf>
  101b85:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b96:	eb 3f                	jmp    101bd7 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 50 40             	mov    0x40(%eax),%edx
  101b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ba1:	21 d0                	and    %edx,%eax
  101ba3:	85 c0                	test   %eax,%eax
  101ba5:	74 29                	je     101bd0 <print_trapframe+0x168>
  101ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101baa:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bb1:	85 c0                	test   %eax,%eax
  101bb3:	74 1b                	je     101bd0 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb8:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bbf:	83 ec 08             	sub    $0x8,%esp
  101bc2:	50                   	push   %eax
  101bc3:	68 82 5d 10 00       	push   $0x105d82
  101bc8:	e8 9f e6 ff ff       	call   10026c <cprintf>
  101bcd:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bd4:	d1 65 f0             	shll   -0x10(%ebp)
  101bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bda:	83 f8 17             	cmp    $0x17,%eax
  101bdd:	76 b9                	jbe    101b98 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101be2:	8b 40 40             	mov    0x40(%eax),%eax
  101be5:	25 00 30 00 00       	and    $0x3000,%eax
  101bea:	c1 e8 0c             	shr    $0xc,%eax
  101bed:	83 ec 08             	sub    $0x8,%esp
  101bf0:	50                   	push   %eax
  101bf1:	68 86 5d 10 00       	push   $0x105d86
  101bf6:	e8 71 e6 ff ff       	call   10026c <cprintf>
  101bfb:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bfe:	83 ec 0c             	sub    $0xc,%esp
  101c01:	ff 75 08             	pushl  0x8(%ebp)
  101c04:	e8 49 fe ff ff       	call   101a52 <trap_in_kernel>
  101c09:	83 c4 10             	add    $0x10,%esp
  101c0c:	85 c0                	test   %eax,%eax
  101c0e:	75 32                	jne    101c42 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 40 44             	mov    0x44(%eax),%eax
  101c16:	83 ec 08             	sub    $0x8,%esp
  101c19:	50                   	push   %eax
  101c1a:	68 8f 5d 10 00       	push   $0x105d8f
  101c1f:	e8 48 e6 ff ff       	call   10026c <cprintf>
  101c24:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c2e:	0f b7 c0             	movzwl %ax,%eax
  101c31:	83 ec 08             	sub    $0x8,%esp
  101c34:	50                   	push   %eax
  101c35:	68 9e 5d 10 00       	push   $0x105d9e
  101c3a:	e8 2d e6 ff ff       	call   10026c <cprintf>
  101c3f:	83 c4 10             	add    $0x10,%esp
    }
}
  101c42:	90                   	nop
  101c43:	c9                   	leave  
  101c44:	c3                   	ret    

00101c45 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c45:	55                   	push   %ebp
  101c46:	89 e5                	mov    %esp,%ebp
  101c48:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 00                	mov    (%eax),%eax
  101c50:	83 ec 08             	sub    $0x8,%esp
  101c53:	50                   	push   %eax
  101c54:	68 b1 5d 10 00       	push   $0x105db1
  101c59:	e8 0e e6 ff ff       	call   10026c <cprintf>
  101c5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 04             	mov    0x4(%eax),%eax
  101c67:	83 ec 08             	sub    $0x8,%esp
  101c6a:	50                   	push   %eax
  101c6b:	68 c0 5d 10 00       	push   $0x105dc0
  101c70:	e8 f7 e5 ff ff       	call   10026c <cprintf>
  101c75:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c78:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7b:	8b 40 08             	mov    0x8(%eax),%eax
  101c7e:	83 ec 08             	sub    $0x8,%esp
  101c81:	50                   	push   %eax
  101c82:	68 cf 5d 10 00       	push   $0x105dcf
  101c87:	e8 e0 e5 ff ff       	call   10026c <cprintf>
  101c8c:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c92:	8b 40 0c             	mov    0xc(%eax),%eax
  101c95:	83 ec 08             	sub    $0x8,%esp
  101c98:	50                   	push   %eax
  101c99:	68 de 5d 10 00       	push   $0x105dde
  101c9e:	e8 c9 e5 ff ff       	call   10026c <cprintf>
  101ca3:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca9:	8b 40 10             	mov    0x10(%eax),%eax
  101cac:	83 ec 08             	sub    $0x8,%esp
  101caf:	50                   	push   %eax
  101cb0:	68 ed 5d 10 00       	push   $0x105ded
  101cb5:	e8 b2 e5 ff ff       	call   10026c <cprintf>
  101cba:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc0:	8b 40 14             	mov    0x14(%eax),%eax
  101cc3:	83 ec 08             	sub    $0x8,%esp
  101cc6:	50                   	push   %eax
  101cc7:	68 fc 5d 10 00       	push   $0x105dfc
  101ccc:	e8 9b e5 ff ff       	call   10026c <cprintf>
  101cd1:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	8b 40 18             	mov    0x18(%eax),%eax
  101cda:	83 ec 08             	sub    $0x8,%esp
  101cdd:	50                   	push   %eax
  101cde:	68 0b 5e 10 00       	push   $0x105e0b
  101ce3:	e8 84 e5 ff ff       	call   10026c <cprintf>
  101ce8:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cf1:	83 ec 08             	sub    $0x8,%esp
  101cf4:	50                   	push   %eax
  101cf5:	68 1a 5e 10 00       	push   $0x105e1a
  101cfa:	e8 6d e5 ff ff       	call   10026c <cprintf>
  101cff:	83 c4 10             	add    $0x10,%esp
}
  101d02:	90                   	nop
  101d03:	c9                   	leave  
  101d04:	c3                   	ret    

00101d05 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d05:	55                   	push   %ebp
  101d06:	89 e5                	mov    %esp,%ebp
  101d08:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0e:	8b 40 30             	mov    0x30(%eax),%eax
  101d11:	83 f8 2f             	cmp    $0x2f,%eax
  101d14:	77 1d                	ja     101d33 <trap_dispatch+0x2e>
  101d16:	83 f8 2e             	cmp    $0x2e,%eax
  101d19:	0f 83 f4 00 00 00    	jae    101e13 <trap_dispatch+0x10e>
  101d1f:	83 f8 21             	cmp    $0x21,%eax
  101d22:	74 7e                	je     101da2 <trap_dispatch+0x9d>
  101d24:	83 f8 24             	cmp    $0x24,%eax
  101d27:	74 55                	je     101d7e <trap_dispatch+0x79>
  101d29:	83 f8 20             	cmp    $0x20,%eax
  101d2c:	74 16                	je     101d44 <trap_dispatch+0x3f>
  101d2e:	e9 aa 00 00 00       	jmp    101ddd <trap_dispatch+0xd8>
  101d33:	83 e8 78             	sub    $0x78,%eax
  101d36:	83 f8 01             	cmp    $0x1,%eax
  101d39:	0f 87 9e 00 00 00    	ja     101ddd <trap_dispatch+0xd8>
  101d3f:	e9 82 00 00 00       	jmp    101dc6 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d44:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d49:	83 c0 01             	add    $0x1,%eax
  101d4c:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d51:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d57:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d5c:	89 c8                	mov    %ecx,%eax
  101d5e:	f7 e2                	mul    %edx
  101d60:	89 d0                	mov    %edx,%eax
  101d62:	c1 e8 05             	shr    $0x5,%eax
  101d65:	6b c0 64             	imul   $0x64,%eax,%eax
  101d68:	29 c1                	sub    %eax,%ecx
  101d6a:	89 c8                	mov    %ecx,%eax
  101d6c:	85 c0                	test   %eax,%eax
  101d6e:	0f 85 a2 00 00 00    	jne    101e16 <trap_dispatch+0x111>
            print_ticks();
  101d74:	e8 fa fa ff ff       	call   101873 <print_ticks>
        }
        break;
  101d79:	e9 98 00 00 00       	jmp    101e16 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d7e:	e8 ad f8 ff ff       	call   101630 <cons_getc>
  101d83:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d86:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d8a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d8e:	83 ec 04             	sub    $0x4,%esp
  101d91:	52                   	push   %edx
  101d92:	50                   	push   %eax
  101d93:	68 29 5e 10 00       	push   $0x105e29
  101d98:	e8 cf e4 ff ff       	call   10026c <cprintf>
  101d9d:	83 c4 10             	add    $0x10,%esp
        break;
  101da0:	eb 75                	jmp    101e17 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101da2:	e8 89 f8 ff ff       	call   101630 <cons_getc>
  101da7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101daa:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101db2:	83 ec 04             	sub    $0x4,%esp
  101db5:	52                   	push   %edx
  101db6:	50                   	push   %eax
  101db7:	68 3b 5e 10 00       	push   $0x105e3b
  101dbc:	e8 ab e4 ff ff       	call   10026c <cprintf>
  101dc1:	83 c4 10             	add    $0x10,%esp
        break;
  101dc4:	eb 51                	jmp    101e17 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dc6:	83 ec 04             	sub    $0x4,%esp
  101dc9:	68 4a 5e 10 00       	push   $0x105e4a
  101dce:	68 af 00 00 00       	push   $0xaf
  101dd3:	68 6e 5c 10 00       	push   $0x105c6e
  101dd8:	e8 f5 e5 ff ff       	call   1003d2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  101de0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de4:	0f b7 c0             	movzwl %ax,%eax
  101de7:	83 e0 03             	and    $0x3,%eax
  101dea:	85 c0                	test   %eax,%eax
  101dec:	75 29                	jne    101e17 <trap_dispatch+0x112>
            print_trapframe(tf);
  101dee:	83 ec 0c             	sub    $0xc,%esp
  101df1:	ff 75 08             	pushl  0x8(%ebp)
  101df4:	e8 6f fc ff ff       	call   101a68 <print_trapframe>
  101df9:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101dfc:	83 ec 04             	sub    $0x4,%esp
  101dff:	68 5a 5e 10 00       	push   $0x105e5a
  101e04:	68 b9 00 00 00       	push   $0xb9
  101e09:	68 6e 5c 10 00       	push   $0x105c6e
  101e0e:	e8 bf e5 ff ff       	call   1003d2 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e13:	90                   	nop
  101e14:	eb 01                	jmp    101e17 <trap_dispatch+0x112>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  101e16:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e17:	90                   	nop
  101e18:	c9                   	leave  
  101e19:	c3                   	ret    

00101e1a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e1a:	55                   	push   %ebp
  101e1b:	89 e5                	mov    %esp,%ebp
  101e1d:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e20:	83 ec 0c             	sub    $0xc,%esp
  101e23:	ff 75 08             	pushl  0x8(%ebp)
  101e26:	e8 da fe ff ff       	call   101d05 <trap_dispatch>
  101e2b:	83 c4 10             	add    $0x10,%esp
}
  101e2e:	90                   	nop
  101e2f:	c9                   	leave  
  101e30:	c3                   	ret    

00101e31 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $0
  101e33:	6a 00                	push   $0x0
  jmp __alltraps
  101e35:	e9 67 0a 00 00       	jmp    1028a1 <__alltraps>

00101e3a <vector1>:
.globl vector1
vector1:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $1
  101e3c:	6a 01                	push   $0x1
  jmp __alltraps
  101e3e:	e9 5e 0a 00 00       	jmp    1028a1 <__alltraps>

00101e43 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $2
  101e45:	6a 02                	push   $0x2
  jmp __alltraps
  101e47:	e9 55 0a 00 00       	jmp    1028a1 <__alltraps>

00101e4c <vector3>:
.globl vector3
vector3:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $3
  101e4e:	6a 03                	push   $0x3
  jmp __alltraps
  101e50:	e9 4c 0a 00 00       	jmp    1028a1 <__alltraps>

00101e55 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $4
  101e57:	6a 04                	push   $0x4
  jmp __alltraps
  101e59:	e9 43 0a 00 00       	jmp    1028a1 <__alltraps>

00101e5e <vector5>:
.globl vector5
vector5:
  pushl $0
  101e5e:	6a 00                	push   $0x0
  pushl $5
  101e60:	6a 05                	push   $0x5
  jmp __alltraps
  101e62:	e9 3a 0a 00 00       	jmp    1028a1 <__alltraps>

00101e67 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $6
  101e69:	6a 06                	push   $0x6
  jmp __alltraps
  101e6b:	e9 31 0a 00 00       	jmp    1028a1 <__alltraps>

00101e70 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e70:	6a 00                	push   $0x0
  pushl $7
  101e72:	6a 07                	push   $0x7
  jmp __alltraps
  101e74:	e9 28 0a 00 00       	jmp    1028a1 <__alltraps>

00101e79 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e79:	6a 08                	push   $0x8
  jmp __alltraps
  101e7b:	e9 21 0a 00 00       	jmp    1028a1 <__alltraps>

00101e80 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e80:	6a 09                	push   $0x9
  jmp __alltraps
  101e82:	e9 1a 0a 00 00       	jmp    1028a1 <__alltraps>

00101e87 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e87:	6a 0a                	push   $0xa
  jmp __alltraps
  101e89:	e9 13 0a 00 00       	jmp    1028a1 <__alltraps>

00101e8e <vector11>:
.globl vector11
vector11:
  pushl $11
  101e8e:	6a 0b                	push   $0xb
  jmp __alltraps
  101e90:	e9 0c 0a 00 00       	jmp    1028a1 <__alltraps>

00101e95 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e95:	6a 0c                	push   $0xc
  jmp __alltraps
  101e97:	e9 05 0a 00 00       	jmp    1028a1 <__alltraps>

00101e9c <vector13>:
.globl vector13
vector13:
  pushl $13
  101e9c:	6a 0d                	push   $0xd
  jmp __alltraps
  101e9e:	e9 fe 09 00 00       	jmp    1028a1 <__alltraps>

00101ea3 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ea3:	6a 0e                	push   $0xe
  jmp __alltraps
  101ea5:	e9 f7 09 00 00       	jmp    1028a1 <__alltraps>

00101eaa <vector15>:
.globl vector15
vector15:
  pushl $0
  101eaa:	6a 00                	push   $0x0
  pushl $15
  101eac:	6a 0f                	push   $0xf
  jmp __alltraps
  101eae:	e9 ee 09 00 00       	jmp    1028a1 <__alltraps>

00101eb3 <vector16>:
.globl vector16
vector16:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $16
  101eb5:	6a 10                	push   $0x10
  jmp __alltraps
  101eb7:	e9 e5 09 00 00       	jmp    1028a1 <__alltraps>

00101ebc <vector17>:
.globl vector17
vector17:
  pushl $17
  101ebc:	6a 11                	push   $0x11
  jmp __alltraps
  101ebe:	e9 de 09 00 00       	jmp    1028a1 <__alltraps>

00101ec3 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $18
  101ec5:	6a 12                	push   $0x12
  jmp __alltraps
  101ec7:	e9 d5 09 00 00       	jmp    1028a1 <__alltraps>

00101ecc <vector19>:
.globl vector19
vector19:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $19
  101ece:	6a 13                	push   $0x13
  jmp __alltraps
  101ed0:	e9 cc 09 00 00       	jmp    1028a1 <__alltraps>

00101ed5 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $20
  101ed7:	6a 14                	push   $0x14
  jmp __alltraps
  101ed9:	e9 c3 09 00 00       	jmp    1028a1 <__alltraps>

00101ede <vector21>:
.globl vector21
vector21:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $21
  101ee0:	6a 15                	push   $0x15
  jmp __alltraps
  101ee2:	e9 ba 09 00 00       	jmp    1028a1 <__alltraps>

00101ee7 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $22
  101ee9:	6a 16                	push   $0x16
  jmp __alltraps
  101eeb:	e9 b1 09 00 00       	jmp    1028a1 <__alltraps>

00101ef0 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $23
  101ef2:	6a 17                	push   $0x17
  jmp __alltraps
  101ef4:	e9 a8 09 00 00       	jmp    1028a1 <__alltraps>

00101ef9 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $24
  101efb:	6a 18                	push   $0x18
  jmp __alltraps
  101efd:	e9 9f 09 00 00       	jmp    1028a1 <__alltraps>

00101f02 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $25
  101f04:	6a 19                	push   $0x19
  jmp __alltraps
  101f06:	e9 96 09 00 00       	jmp    1028a1 <__alltraps>

00101f0b <vector26>:
.globl vector26
vector26:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $26
  101f0d:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f0f:	e9 8d 09 00 00       	jmp    1028a1 <__alltraps>

00101f14 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $27
  101f16:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f18:	e9 84 09 00 00       	jmp    1028a1 <__alltraps>

00101f1d <vector28>:
.globl vector28
vector28:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $28
  101f1f:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f21:	e9 7b 09 00 00       	jmp    1028a1 <__alltraps>

00101f26 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $29
  101f28:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f2a:	e9 72 09 00 00       	jmp    1028a1 <__alltraps>

00101f2f <vector30>:
.globl vector30
vector30:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $30
  101f31:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f33:	e9 69 09 00 00       	jmp    1028a1 <__alltraps>

00101f38 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $31
  101f3a:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f3c:	e9 60 09 00 00       	jmp    1028a1 <__alltraps>

00101f41 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $32
  101f43:	6a 20                	push   $0x20
  jmp __alltraps
  101f45:	e9 57 09 00 00       	jmp    1028a1 <__alltraps>

00101f4a <vector33>:
.globl vector33
vector33:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $33
  101f4c:	6a 21                	push   $0x21
  jmp __alltraps
  101f4e:	e9 4e 09 00 00       	jmp    1028a1 <__alltraps>

00101f53 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $34
  101f55:	6a 22                	push   $0x22
  jmp __alltraps
  101f57:	e9 45 09 00 00       	jmp    1028a1 <__alltraps>

00101f5c <vector35>:
.globl vector35
vector35:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $35
  101f5e:	6a 23                	push   $0x23
  jmp __alltraps
  101f60:	e9 3c 09 00 00       	jmp    1028a1 <__alltraps>

00101f65 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $36
  101f67:	6a 24                	push   $0x24
  jmp __alltraps
  101f69:	e9 33 09 00 00       	jmp    1028a1 <__alltraps>

00101f6e <vector37>:
.globl vector37
vector37:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $37
  101f70:	6a 25                	push   $0x25
  jmp __alltraps
  101f72:	e9 2a 09 00 00       	jmp    1028a1 <__alltraps>

00101f77 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $38
  101f79:	6a 26                	push   $0x26
  jmp __alltraps
  101f7b:	e9 21 09 00 00       	jmp    1028a1 <__alltraps>

00101f80 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $39
  101f82:	6a 27                	push   $0x27
  jmp __alltraps
  101f84:	e9 18 09 00 00       	jmp    1028a1 <__alltraps>

00101f89 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $40
  101f8b:	6a 28                	push   $0x28
  jmp __alltraps
  101f8d:	e9 0f 09 00 00       	jmp    1028a1 <__alltraps>

00101f92 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $41
  101f94:	6a 29                	push   $0x29
  jmp __alltraps
  101f96:	e9 06 09 00 00       	jmp    1028a1 <__alltraps>

00101f9b <vector42>:
.globl vector42
vector42:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $42
  101f9d:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f9f:	e9 fd 08 00 00       	jmp    1028a1 <__alltraps>

00101fa4 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $43
  101fa6:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fa8:	e9 f4 08 00 00       	jmp    1028a1 <__alltraps>

00101fad <vector44>:
.globl vector44
vector44:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $44
  101faf:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fb1:	e9 eb 08 00 00       	jmp    1028a1 <__alltraps>

00101fb6 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $45
  101fb8:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fba:	e9 e2 08 00 00       	jmp    1028a1 <__alltraps>

00101fbf <vector46>:
.globl vector46
vector46:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $46
  101fc1:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fc3:	e9 d9 08 00 00       	jmp    1028a1 <__alltraps>

00101fc8 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $47
  101fca:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fcc:	e9 d0 08 00 00       	jmp    1028a1 <__alltraps>

00101fd1 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $48
  101fd3:	6a 30                	push   $0x30
  jmp __alltraps
  101fd5:	e9 c7 08 00 00       	jmp    1028a1 <__alltraps>

00101fda <vector49>:
.globl vector49
vector49:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $49
  101fdc:	6a 31                	push   $0x31
  jmp __alltraps
  101fde:	e9 be 08 00 00       	jmp    1028a1 <__alltraps>

00101fe3 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $50
  101fe5:	6a 32                	push   $0x32
  jmp __alltraps
  101fe7:	e9 b5 08 00 00       	jmp    1028a1 <__alltraps>

00101fec <vector51>:
.globl vector51
vector51:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $51
  101fee:	6a 33                	push   $0x33
  jmp __alltraps
  101ff0:	e9 ac 08 00 00       	jmp    1028a1 <__alltraps>

00101ff5 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $52
  101ff7:	6a 34                	push   $0x34
  jmp __alltraps
  101ff9:	e9 a3 08 00 00       	jmp    1028a1 <__alltraps>

00101ffe <vector53>:
.globl vector53
vector53:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $53
  102000:	6a 35                	push   $0x35
  jmp __alltraps
  102002:	e9 9a 08 00 00       	jmp    1028a1 <__alltraps>

00102007 <vector54>:
.globl vector54
vector54:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $54
  102009:	6a 36                	push   $0x36
  jmp __alltraps
  10200b:	e9 91 08 00 00       	jmp    1028a1 <__alltraps>

00102010 <vector55>:
.globl vector55
vector55:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $55
  102012:	6a 37                	push   $0x37
  jmp __alltraps
  102014:	e9 88 08 00 00       	jmp    1028a1 <__alltraps>

00102019 <vector56>:
.globl vector56
vector56:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $56
  10201b:	6a 38                	push   $0x38
  jmp __alltraps
  10201d:	e9 7f 08 00 00       	jmp    1028a1 <__alltraps>

00102022 <vector57>:
.globl vector57
vector57:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $57
  102024:	6a 39                	push   $0x39
  jmp __alltraps
  102026:	e9 76 08 00 00       	jmp    1028a1 <__alltraps>

0010202b <vector58>:
.globl vector58
vector58:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $58
  10202d:	6a 3a                	push   $0x3a
  jmp __alltraps
  10202f:	e9 6d 08 00 00       	jmp    1028a1 <__alltraps>

00102034 <vector59>:
.globl vector59
vector59:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $59
  102036:	6a 3b                	push   $0x3b
  jmp __alltraps
  102038:	e9 64 08 00 00       	jmp    1028a1 <__alltraps>

0010203d <vector60>:
.globl vector60
vector60:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $60
  10203f:	6a 3c                	push   $0x3c
  jmp __alltraps
  102041:	e9 5b 08 00 00       	jmp    1028a1 <__alltraps>

00102046 <vector61>:
.globl vector61
vector61:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $61
  102048:	6a 3d                	push   $0x3d
  jmp __alltraps
  10204a:	e9 52 08 00 00       	jmp    1028a1 <__alltraps>

0010204f <vector62>:
.globl vector62
vector62:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $62
  102051:	6a 3e                	push   $0x3e
  jmp __alltraps
  102053:	e9 49 08 00 00       	jmp    1028a1 <__alltraps>

00102058 <vector63>:
.globl vector63
vector63:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $63
  10205a:	6a 3f                	push   $0x3f
  jmp __alltraps
  10205c:	e9 40 08 00 00       	jmp    1028a1 <__alltraps>

00102061 <vector64>:
.globl vector64
vector64:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $64
  102063:	6a 40                	push   $0x40
  jmp __alltraps
  102065:	e9 37 08 00 00       	jmp    1028a1 <__alltraps>

0010206a <vector65>:
.globl vector65
vector65:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $65
  10206c:	6a 41                	push   $0x41
  jmp __alltraps
  10206e:	e9 2e 08 00 00       	jmp    1028a1 <__alltraps>

00102073 <vector66>:
.globl vector66
vector66:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $66
  102075:	6a 42                	push   $0x42
  jmp __alltraps
  102077:	e9 25 08 00 00       	jmp    1028a1 <__alltraps>

0010207c <vector67>:
.globl vector67
vector67:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $67
  10207e:	6a 43                	push   $0x43
  jmp __alltraps
  102080:	e9 1c 08 00 00       	jmp    1028a1 <__alltraps>

00102085 <vector68>:
.globl vector68
vector68:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $68
  102087:	6a 44                	push   $0x44
  jmp __alltraps
  102089:	e9 13 08 00 00       	jmp    1028a1 <__alltraps>

0010208e <vector69>:
.globl vector69
vector69:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $69
  102090:	6a 45                	push   $0x45
  jmp __alltraps
  102092:	e9 0a 08 00 00       	jmp    1028a1 <__alltraps>

00102097 <vector70>:
.globl vector70
vector70:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $70
  102099:	6a 46                	push   $0x46
  jmp __alltraps
  10209b:	e9 01 08 00 00       	jmp    1028a1 <__alltraps>

001020a0 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $71
  1020a2:	6a 47                	push   $0x47
  jmp __alltraps
  1020a4:	e9 f8 07 00 00       	jmp    1028a1 <__alltraps>

001020a9 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $72
  1020ab:	6a 48                	push   $0x48
  jmp __alltraps
  1020ad:	e9 ef 07 00 00       	jmp    1028a1 <__alltraps>

001020b2 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $73
  1020b4:	6a 49                	push   $0x49
  jmp __alltraps
  1020b6:	e9 e6 07 00 00       	jmp    1028a1 <__alltraps>

001020bb <vector74>:
.globl vector74
vector74:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $74
  1020bd:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020bf:	e9 dd 07 00 00       	jmp    1028a1 <__alltraps>

001020c4 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $75
  1020c6:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020c8:	e9 d4 07 00 00       	jmp    1028a1 <__alltraps>

001020cd <vector76>:
.globl vector76
vector76:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $76
  1020cf:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020d1:	e9 cb 07 00 00       	jmp    1028a1 <__alltraps>

001020d6 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $77
  1020d8:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020da:	e9 c2 07 00 00       	jmp    1028a1 <__alltraps>

001020df <vector78>:
.globl vector78
vector78:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $78
  1020e1:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020e3:	e9 b9 07 00 00       	jmp    1028a1 <__alltraps>

001020e8 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $79
  1020ea:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020ec:	e9 b0 07 00 00       	jmp    1028a1 <__alltraps>

001020f1 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $80
  1020f3:	6a 50                	push   $0x50
  jmp __alltraps
  1020f5:	e9 a7 07 00 00       	jmp    1028a1 <__alltraps>

001020fa <vector81>:
.globl vector81
vector81:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $81
  1020fc:	6a 51                	push   $0x51
  jmp __alltraps
  1020fe:	e9 9e 07 00 00       	jmp    1028a1 <__alltraps>

00102103 <vector82>:
.globl vector82
vector82:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $82
  102105:	6a 52                	push   $0x52
  jmp __alltraps
  102107:	e9 95 07 00 00       	jmp    1028a1 <__alltraps>

0010210c <vector83>:
.globl vector83
vector83:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $83
  10210e:	6a 53                	push   $0x53
  jmp __alltraps
  102110:	e9 8c 07 00 00       	jmp    1028a1 <__alltraps>

00102115 <vector84>:
.globl vector84
vector84:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $84
  102117:	6a 54                	push   $0x54
  jmp __alltraps
  102119:	e9 83 07 00 00       	jmp    1028a1 <__alltraps>

0010211e <vector85>:
.globl vector85
vector85:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $85
  102120:	6a 55                	push   $0x55
  jmp __alltraps
  102122:	e9 7a 07 00 00       	jmp    1028a1 <__alltraps>

00102127 <vector86>:
.globl vector86
vector86:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $86
  102129:	6a 56                	push   $0x56
  jmp __alltraps
  10212b:	e9 71 07 00 00       	jmp    1028a1 <__alltraps>

00102130 <vector87>:
.globl vector87
vector87:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $87
  102132:	6a 57                	push   $0x57
  jmp __alltraps
  102134:	e9 68 07 00 00       	jmp    1028a1 <__alltraps>

00102139 <vector88>:
.globl vector88
vector88:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $88
  10213b:	6a 58                	push   $0x58
  jmp __alltraps
  10213d:	e9 5f 07 00 00       	jmp    1028a1 <__alltraps>

00102142 <vector89>:
.globl vector89
vector89:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $89
  102144:	6a 59                	push   $0x59
  jmp __alltraps
  102146:	e9 56 07 00 00       	jmp    1028a1 <__alltraps>

0010214b <vector90>:
.globl vector90
vector90:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $90
  10214d:	6a 5a                	push   $0x5a
  jmp __alltraps
  10214f:	e9 4d 07 00 00       	jmp    1028a1 <__alltraps>

00102154 <vector91>:
.globl vector91
vector91:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $91
  102156:	6a 5b                	push   $0x5b
  jmp __alltraps
  102158:	e9 44 07 00 00       	jmp    1028a1 <__alltraps>

0010215d <vector92>:
.globl vector92
vector92:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $92
  10215f:	6a 5c                	push   $0x5c
  jmp __alltraps
  102161:	e9 3b 07 00 00       	jmp    1028a1 <__alltraps>

00102166 <vector93>:
.globl vector93
vector93:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $93
  102168:	6a 5d                	push   $0x5d
  jmp __alltraps
  10216a:	e9 32 07 00 00       	jmp    1028a1 <__alltraps>

0010216f <vector94>:
.globl vector94
vector94:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $94
  102171:	6a 5e                	push   $0x5e
  jmp __alltraps
  102173:	e9 29 07 00 00       	jmp    1028a1 <__alltraps>

00102178 <vector95>:
.globl vector95
vector95:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $95
  10217a:	6a 5f                	push   $0x5f
  jmp __alltraps
  10217c:	e9 20 07 00 00       	jmp    1028a1 <__alltraps>

00102181 <vector96>:
.globl vector96
vector96:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $96
  102183:	6a 60                	push   $0x60
  jmp __alltraps
  102185:	e9 17 07 00 00       	jmp    1028a1 <__alltraps>

0010218a <vector97>:
.globl vector97
vector97:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $97
  10218c:	6a 61                	push   $0x61
  jmp __alltraps
  10218e:	e9 0e 07 00 00       	jmp    1028a1 <__alltraps>

00102193 <vector98>:
.globl vector98
vector98:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $98
  102195:	6a 62                	push   $0x62
  jmp __alltraps
  102197:	e9 05 07 00 00       	jmp    1028a1 <__alltraps>

0010219c <vector99>:
.globl vector99
vector99:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $99
  10219e:	6a 63                	push   $0x63
  jmp __alltraps
  1021a0:	e9 fc 06 00 00       	jmp    1028a1 <__alltraps>

001021a5 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $100
  1021a7:	6a 64                	push   $0x64
  jmp __alltraps
  1021a9:	e9 f3 06 00 00       	jmp    1028a1 <__alltraps>

001021ae <vector101>:
.globl vector101
vector101:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $101
  1021b0:	6a 65                	push   $0x65
  jmp __alltraps
  1021b2:	e9 ea 06 00 00       	jmp    1028a1 <__alltraps>

001021b7 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $102
  1021b9:	6a 66                	push   $0x66
  jmp __alltraps
  1021bb:	e9 e1 06 00 00       	jmp    1028a1 <__alltraps>

001021c0 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $103
  1021c2:	6a 67                	push   $0x67
  jmp __alltraps
  1021c4:	e9 d8 06 00 00       	jmp    1028a1 <__alltraps>

001021c9 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $104
  1021cb:	6a 68                	push   $0x68
  jmp __alltraps
  1021cd:	e9 cf 06 00 00       	jmp    1028a1 <__alltraps>

001021d2 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $105
  1021d4:	6a 69                	push   $0x69
  jmp __alltraps
  1021d6:	e9 c6 06 00 00       	jmp    1028a1 <__alltraps>

001021db <vector106>:
.globl vector106
vector106:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $106
  1021dd:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021df:	e9 bd 06 00 00       	jmp    1028a1 <__alltraps>

001021e4 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $107
  1021e6:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021e8:	e9 b4 06 00 00       	jmp    1028a1 <__alltraps>

001021ed <vector108>:
.globl vector108
vector108:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $108
  1021ef:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021f1:	e9 ab 06 00 00       	jmp    1028a1 <__alltraps>

001021f6 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $109
  1021f8:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021fa:	e9 a2 06 00 00       	jmp    1028a1 <__alltraps>

001021ff <vector110>:
.globl vector110
vector110:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $110
  102201:	6a 6e                	push   $0x6e
  jmp __alltraps
  102203:	e9 99 06 00 00       	jmp    1028a1 <__alltraps>

00102208 <vector111>:
.globl vector111
vector111:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $111
  10220a:	6a 6f                	push   $0x6f
  jmp __alltraps
  10220c:	e9 90 06 00 00       	jmp    1028a1 <__alltraps>

00102211 <vector112>:
.globl vector112
vector112:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $112
  102213:	6a 70                	push   $0x70
  jmp __alltraps
  102215:	e9 87 06 00 00       	jmp    1028a1 <__alltraps>

0010221a <vector113>:
.globl vector113
vector113:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $113
  10221c:	6a 71                	push   $0x71
  jmp __alltraps
  10221e:	e9 7e 06 00 00       	jmp    1028a1 <__alltraps>

00102223 <vector114>:
.globl vector114
vector114:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $114
  102225:	6a 72                	push   $0x72
  jmp __alltraps
  102227:	e9 75 06 00 00       	jmp    1028a1 <__alltraps>

0010222c <vector115>:
.globl vector115
vector115:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $115
  10222e:	6a 73                	push   $0x73
  jmp __alltraps
  102230:	e9 6c 06 00 00       	jmp    1028a1 <__alltraps>

00102235 <vector116>:
.globl vector116
vector116:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $116
  102237:	6a 74                	push   $0x74
  jmp __alltraps
  102239:	e9 63 06 00 00       	jmp    1028a1 <__alltraps>

0010223e <vector117>:
.globl vector117
vector117:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $117
  102240:	6a 75                	push   $0x75
  jmp __alltraps
  102242:	e9 5a 06 00 00       	jmp    1028a1 <__alltraps>

00102247 <vector118>:
.globl vector118
vector118:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $118
  102249:	6a 76                	push   $0x76
  jmp __alltraps
  10224b:	e9 51 06 00 00       	jmp    1028a1 <__alltraps>

00102250 <vector119>:
.globl vector119
vector119:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $119
  102252:	6a 77                	push   $0x77
  jmp __alltraps
  102254:	e9 48 06 00 00       	jmp    1028a1 <__alltraps>

00102259 <vector120>:
.globl vector120
vector120:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $120
  10225b:	6a 78                	push   $0x78
  jmp __alltraps
  10225d:	e9 3f 06 00 00       	jmp    1028a1 <__alltraps>

00102262 <vector121>:
.globl vector121
vector121:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $121
  102264:	6a 79                	push   $0x79
  jmp __alltraps
  102266:	e9 36 06 00 00       	jmp    1028a1 <__alltraps>

0010226b <vector122>:
.globl vector122
vector122:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $122
  10226d:	6a 7a                	push   $0x7a
  jmp __alltraps
  10226f:	e9 2d 06 00 00       	jmp    1028a1 <__alltraps>

00102274 <vector123>:
.globl vector123
vector123:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $123
  102276:	6a 7b                	push   $0x7b
  jmp __alltraps
  102278:	e9 24 06 00 00       	jmp    1028a1 <__alltraps>

0010227d <vector124>:
.globl vector124
vector124:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $124
  10227f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102281:	e9 1b 06 00 00       	jmp    1028a1 <__alltraps>

00102286 <vector125>:
.globl vector125
vector125:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $125
  102288:	6a 7d                	push   $0x7d
  jmp __alltraps
  10228a:	e9 12 06 00 00       	jmp    1028a1 <__alltraps>

0010228f <vector126>:
.globl vector126
vector126:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $126
  102291:	6a 7e                	push   $0x7e
  jmp __alltraps
  102293:	e9 09 06 00 00       	jmp    1028a1 <__alltraps>

00102298 <vector127>:
.globl vector127
vector127:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $127
  10229a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10229c:	e9 00 06 00 00       	jmp    1028a1 <__alltraps>

001022a1 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $128
  1022a3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022a8:	e9 f4 05 00 00       	jmp    1028a1 <__alltraps>

001022ad <vector129>:
.globl vector129
vector129:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $129
  1022af:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022b4:	e9 e8 05 00 00       	jmp    1028a1 <__alltraps>

001022b9 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $130
  1022bb:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022c0:	e9 dc 05 00 00       	jmp    1028a1 <__alltraps>

001022c5 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $131
  1022c7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022cc:	e9 d0 05 00 00       	jmp    1028a1 <__alltraps>

001022d1 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $132
  1022d3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022d8:	e9 c4 05 00 00       	jmp    1028a1 <__alltraps>

001022dd <vector133>:
.globl vector133
vector133:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $133
  1022df:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022e4:	e9 b8 05 00 00       	jmp    1028a1 <__alltraps>

001022e9 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $134
  1022eb:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022f0:	e9 ac 05 00 00       	jmp    1028a1 <__alltraps>

001022f5 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $135
  1022f7:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022fc:	e9 a0 05 00 00       	jmp    1028a1 <__alltraps>

00102301 <vector136>:
.globl vector136
vector136:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $136
  102303:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102308:	e9 94 05 00 00       	jmp    1028a1 <__alltraps>

0010230d <vector137>:
.globl vector137
vector137:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $137
  10230f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102314:	e9 88 05 00 00       	jmp    1028a1 <__alltraps>

00102319 <vector138>:
.globl vector138
vector138:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $138
  10231b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102320:	e9 7c 05 00 00       	jmp    1028a1 <__alltraps>

00102325 <vector139>:
.globl vector139
vector139:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $139
  102327:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10232c:	e9 70 05 00 00       	jmp    1028a1 <__alltraps>

00102331 <vector140>:
.globl vector140
vector140:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $140
  102333:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102338:	e9 64 05 00 00       	jmp    1028a1 <__alltraps>

0010233d <vector141>:
.globl vector141
vector141:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $141
  10233f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102344:	e9 58 05 00 00       	jmp    1028a1 <__alltraps>

00102349 <vector142>:
.globl vector142
vector142:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $142
  10234b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102350:	e9 4c 05 00 00       	jmp    1028a1 <__alltraps>

00102355 <vector143>:
.globl vector143
vector143:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $143
  102357:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10235c:	e9 40 05 00 00       	jmp    1028a1 <__alltraps>

00102361 <vector144>:
.globl vector144
vector144:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $144
  102363:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102368:	e9 34 05 00 00       	jmp    1028a1 <__alltraps>

0010236d <vector145>:
.globl vector145
vector145:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $145
  10236f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102374:	e9 28 05 00 00       	jmp    1028a1 <__alltraps>

00102379 <vector146>:
.globl vector146
vector146:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $146
  10237b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102380:	e9 1c 05 00 00       	jmp    1028a1 <__alltraps>

00102385 <vector147>:
.globl vector147
vector147:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $147
  102387:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10238c:	e9 10 05 00 00       	jmp    1028a1 <__alltraps>

00102391 <vector148>:
.globl vector148
vector148:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $148
  102393:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102398:	e9 04 05 00 00       	jmp    1028a1 <__alltraps>

0010239d <vector149>:
.globl vector149
vector149:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $149
  10239f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023a4:	e9 f8 04 00 00       	jmp    1028a1 <__alltraps>

001023a9 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $150
  1023ab:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023b0:	e9 ec 04 00 00       	jmp    1028a1 <__alltraps>

001023b5 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $151
  1023b7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023bc:	e9 e0 04 00 00       	jmp    1028a1 <__alltraps>

001023c1 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $152
  1023c3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023c8:	e9 d4 04 00 00       	jmp    1028a1 <__alltraps>

001023cd <vector153>:
.globl vector153
vector153:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $153
  1023cf:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023d4:	e9 c8 04 00 00       	jmp    1028a1 <__alltraps>

001023d9 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $154
  1023db:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023e0:	e9 bc 04 00 00       	jmp    1028a1 <__alltraps>

001023e5 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $155
  1023e7:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023ec:	e9 b0 04 00 00       	jmp    1028a1 <__alltraps>

001023f1 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $156
  1023f3:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023f8:	e9 a4 04 00 00       	jmp    1028a1 <__alltraps>

001023fd <vector157>:
.globl vector157
vector157:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $157
  1023ff:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102404:	e9 98 04 00 00       	jmp    1028a1 <__alltraps>

00102409 <vector158>:
.globl vector158
vector158:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $158
  10240b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102410:	e9 8c 04 00 00       	jmp    1028a1 <__alltraps>

00102415 <vector159>:
.globl vector159
vector159:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $159
  102417:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10241c:	e9 80 04 00 00       	jmp    1028a1 <__alltraps>

00102421 <vector160>:
.globl vector160
vector160:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $160
  102423:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102428:	e9 74 04 00 00       	jmp    1028a1 <__alltraps>

0010242d <vector161>:
.globl vector161
vector161:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $161
  10242f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102434:	e9 68 04 00 00       	jmp    1028a1 <__alltraps>

00102439 <vector162>:
.globl vector162
vector162:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $162
  10243b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102440:	e9 5c 04 00 00       	jmp    1028a1 <__alltraps>

00102445 <vector163>:
.globl vector163
vector163:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $163
  102447:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10244c:	e9 50 04 00 00       	jmp    1028a1 <__alltraps>

00102451 <vector164>:
.globl vector164
vector164:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $164
  102453:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102458:	e9 44 04 00 00       	jmp    1028a1 <__alltraps>

0010245d <vector165>:
.globl vector165
vector165:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $165
  10245f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102464:	e9 38 04 00 00       	jmp    1028a1 <__alltraps>

00102469 <vector166>:
.globl vector166
vector166:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $166
  10246b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102470:	e9 2c 04 00 00       	jmp    1028a1 <__alltraps>

00102475 <vector167>:
.globl vector167
vector167:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $167
  102477:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10247c:	e9 20 04 00 00       	jmp    1028a1 <__alltraps>

00102481 <vector168>:
.globl vector168
vector168:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $168
  102483:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102488:	e9 14 04 00 00       	jmp    1028a1 <__alltraps>

0010248d <vector169>:
.globl vector169
vector169:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $169
  10248f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102494:	e9 08 04 00 00       	jmp    1028a1 <__alltraps>

00102499 <vector170>:
.globl vector170
vector170:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $170
  10249b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024a0:	e9 fc 03 00 00       	jmp    1028a1 <__alltraps>

001024a5 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $171
  1024a7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024ac:	e9 f0 03 00 00       	jmp    1028a1 <__alltraps>

001024b1 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $172
  1024b3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024b8:	e9 e4 03 00 00       	jmp    1028a1 <__alltraps>

001024bd <vector173>:
.globl vector173
vector173:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $173
  1024bf:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024c4:	e9 d8 03 00 00       	jmp    1028a1 <__alltraps>

001024c9 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $174
  1024cb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024d0:	e9 cc 03 00 00       	jmp    1028a1 <__alltraps>

001024d5 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $175
  1024d7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024dc:	e9 c0 03 00 00       	jmp    1028a1 <__alltraps>

001024e1 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $176
  1024e3:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024e8:	e9 b4 03 00 00       	jmp    1028a1 <__alltraps>

001024ed <vector177>:
.globl vector177
vector177:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $177
  1024ef:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024f4:	e9 a8 03 00 00       	jmp    1028a1 <__alltraps>

001024f9 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $178
  1024fb:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102500:	e9 9c 03 00 00       	jmp    1028a1 <__alltraps>

00102505 <vector179>:
.globl vector179
vector179:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $179
  102507:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10250c:	e9 90 03 00 00       	jmp    1028a1 <__alltraps>

00102511 <vector180>:
.globl vector180
vector180:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $180
  102513:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102518:	e9 84 03 00 00       	jmp    1028a1 <__alltraps>

0010251d <vector181>:
.globl vector181
vector181:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $181
  10251f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102524:	e9 78 03 00 00       	jmp    1028a1 <__alltraps>

00102529 <vector182>:
.globl vector182
vector182:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $182
  10252b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102530:	e9 6c 03 00 00       	jmp    1028a1 <__alltraps>

00102535 <vector183>:
.globl vector183
vector183:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $183
  102537:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10253c:	e9 60 03 00 00       	jmp    1028a1 <__alltraps>

00102541 <vector184>:
.globl vector184
vector184:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $184
  102543:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102548:	e9 54 03 00 00       	jmp    1028a1 <__alltraps>

0010254d <vector185>:
.globl vector185
vector185:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $185
  10254f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102554:	e9 48 03 00 00       	jmp    1028a1 <__alltraps>

00102559 <vector186>:
.globl vector186
vector186:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $186
  10255b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102560:	e9 3c 03 00 00       	jmp    1028a1 <__alltraps>

00102565 <vector187>:
.globl vector187
vector187:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $187
  102567:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10256c:	e9 30 03 00 00       	jmp    1028a1 <__alltraps>

00102571 <vector188>:
.globl vector188
vector188:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $188
  102573:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102578:	e9 24 03 00 00       	jmp    1028a1 <__alltraps>

0010257d <vector189>:
.globl vector189
vector189:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $189
  10257f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102584:	e9 18 03 00 00       	jmp    1028a1 <__alltraps>

00102589 <vector190>:
.globl vector190
vector190:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $190
  10258b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102590:	e9 0c 03 00 00       	jmp    1028a1 <__alltraps>

00102595 <vector191>:
.globl vector191
vector191:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $191
  102597:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10259c:	e9 00 03 00 00       	jmp    1028a1 <__alltraps>

001025a1 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $192
  1025a3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025a8:	e9 f4 02 00 00       	jmp    1028a1 <__alltraps>

001025ad <vector193>:
.globl vector193
vector193:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $193
  1025af:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025b4:	e9 e8 02 00 00       	jmp    1028a1 <__alltraps>

001025b9 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $194
  1025bb:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025c0:	e9 dc 02 00 00       	jmp    1028a1 <__alltraps>

001025c5 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $195
  1025c7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025cc:	e9 d0 02 00 00       	jmp    1028a1 <__alltraps>

001025d1 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $196
  1025d3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025d8:	e9 c4 02 00 00       	jmp    1028a1 <__alltraps>

001025dd <vector197>:
.globl vector197
vector197:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $197
  1025df:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025e4:	e9 b8 02 00 00       	jmp    1028a1 <__alltraps>

001025e9 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $198
  1025eb:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025f0:	e9 ac 02 00 00       	jmp    1028a1 <__alltraps>

001025f5 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $199
  1025f7:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025fc:	e9 a0 02 00 00       	jmp    1028a1 <__alltraps>

00102601 <vector200>:
.globl vector200
vector200:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $200
  102603:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102608:	e9 94 02 00 00       	jmp    1028a1 <__alltraps>

0010260d <vector201>:
.globl vector201
vector201:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $201
  10260f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102614:	e9 88 02 00 00       	jmp    1028a1 <__alltraps>

00102619 <vector202>:
.globl vector202
vector202:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $202
  10261b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102620:	e9 7c 02 00 00       	jmp    1028a1 <__alltraps>

00102625 <vector203>:
.globl vector203
vector203:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $203
  102627:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10262c:	e9 70 02 00 00       	jmp    1028a1 <__alltraps>

00102631 <vector204>:
.globl vector204
vector204:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $204
  102633:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102638:	e9 64 02 00 00       	jmp    1028a1 <__alltraps>

0010263d <vector205>:
.globl vector205
vector205:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $205
  10263f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102644:	e9 58 02 00 00       	jmp    1028a1 <__alltraps>

00102649 <vector206>:
.globl vector206
vector206:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $206
  10264b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102650:	e9 4c 02 00 00       	jmp    1028a1 <__alltraps>

00102655 <vector207>:
.globl vector207
vector207:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $207
  102657:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10265c:	e9 40 02 00 00       	jmp    1028a1 <__alltraps>

00102661 <vector208>:
.globl vector208
vector208:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $208
  102663:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102668:	e9 34 02 00 00       	jmp    1028a1 <__alltraps>

0010266d <vector209>:
.globl vector209
vector209:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $209
  10266f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102674:	e9 28 02 00 00       	jmp    1028a1 <__alltraps>

00102679 <vector210>:
.globl vector210
vector210:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $210
  10267b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102680:	e9 1c 02 00 00       	jmp    1028a1 <__alltraps>

00102685 <vector211>:
.globl vector211
vector211:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $211
  102687:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10268c:	e9 10 02 00 00       	jmp    1028a1 <__alltraps>

00102691 <vector212>:
.globl vector212
vector212:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $212
  102693:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102698:	e9 04 02 00 00       	jmp    1028a1 <__alltraps>

0010269d <vector213>:
.globl vector213
vector213:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $213
  10269f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026a4:	e9 f8 01 00 00       	jmp    1028a1 <__alltraps>

001026a9 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $214
  1026ab:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026b0:	e9 ec 01 00 00       	jmp    1028a1 <__alltraps>

001026b5 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $215
  1026b7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026bc:	e9 e0 01 00 00       	jmp    1028a1 <__alltraps>

001026c1 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $216
  1026c3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026c8:	e9 d4 01 00 00       	jmp    1028a1 <__alltraps>

001026cd <vector217>:
.globl vector217
vector217:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $217
  1026cf:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026d4:	e9 c8 01 00 00       	jmp    1028a1 <__alltraps>

001026d9 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $218
  1026db:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026e0:	e9 bc 01 00 00       	jmp    1028a1 <__alltraps>

001026e5 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $219
  1026e7:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026ec:	e9 b0 01 00 00       	jmp    1028a1 <__alltraps>

001026f1 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $220
  1026f3:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026f8:	e9 a4 01 00 00       	jmp    1028a1 <__alltraps>

001026fd <vector221>:
.globl vector221
vector221:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $221
  1026ff:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102704:	e9 98 01 00 00       	jmp    1028a1 <__alltraps>

00102709 <vector222>:
.globl vector222
vector222:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $222
  10270b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102710:	e9 8c 01 00 00       	jmp    1028a1 <__alltraps>

00102715 <vector223>:
.globl vector223
vector223:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $223
  102717:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10271c:	e9 80 01 00 00       	jmp    1028a1 <__alltraps>

00102721 <vector224>:
.globl vector224
vector224:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $224
  102723:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102728:	e9 74 01 00 00       	jmp    1028a1 <__alltraps>

0010272d <vector225>:
.globl vector225
vector225:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $225
  10272f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102734:	e9 68 01 00 00       	jmp    1028a1 <__alltraps>

00102739 <vector226>:
.globl vector226
vector226:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $226
  10273b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102740:	e9 5c 01 00 00       	jmp    1028a1 <__alltraps>

00102745 <vector227>:
.globl vector227
vector227:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $227
  102747:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10274c:	e9 50 01 00 00       	jmp    1028a1 <__alltraps>

00102751 <vector228>:
.globl vector228
vector228:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $228
  102753:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102758:	e9 44 01 00 00       	jmp    1028a1 <__alltraps>

0010275d <vector229>:
.globl vector229
vector229:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $229
  10275f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102764:	e9 38 01 00 00       	jmp    1028a1 <__alltraps>

00102769 <vector230>:
.globl vector230
vector230:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $230
  10276b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102770:	e9 2c 01 00 00       	jmp    1028a1 <__alltraps>

00102775 <vector231>:
.globl vector231
vector231:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $231
  102777:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10277c:	e9 20 01 00 00       	jmp    1028a1 <__alltraps>

00102781 <vector232>:
.globl vector232
vector232:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $232
  102783:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102788:	e9 14 01 00 00       	jmp    1028a1 <__alltraps>

0010278d <vector233>:
.globl vector233
vector233:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $233
  10278f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102794:	e9 08 01 00 00       	jmp    1028a1 <__alltraps>

00102799 <vector234>:
.globl vector234
vector234:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $234
  10279b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027a0:	e9 fc 00 00 00       	jmp    1028a1 <__alltraps>

001027a5 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $235
  1027a7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027ac:	e9 f0 00 00 00       	jmp    1028a1 <__alltraps>

001027b1 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $236
  1027b3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027b8:	e9 e4 00 00 00       	jmp    1028a1 <__alltraps>

001027bd <vector237>:
.globl vector237
vector237:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $237
  1027bf:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027c4:	e9 d8 00 00 00       	jmp    1028a1 <__alltraps>

001027c9 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $238
  1027cb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027d0:	e9 cc 00 00 00       	jmp    1028a1 <__alltraps>

001027d5 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $239
  1027d7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027dc:	e9 c0 00 00 00       	jmp    1028a1 <__alltraps>

001027e1 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $240
  1027e3:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027e8:	e9 b4 00 00 00       	jmp    1028a1 <__alltraps>

001027ed <vector241>:
.globl vector241
vector241:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $241
  1027ef:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027f4:	e9 a8 00 00 00       	jmp    1028a1 <__alltraps>

001027f9 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $242
  1027fb:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102800:	e9 9c 00 00 00       	jmp    1028a1 <__alltraps>

00102805 <vector243>:
.globl vector243
vector243:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $243
  102807:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10280c:	e9 90 00 00 00       	jmp    1028a1 <__alltraps>

00102811 <vector244>:
.globl vector244
vector244:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $244
  102813:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102818:	e9 84 00 00 00       	jmp    1028a1 <__alltraps>

0010281d <vector245>:
.globl vector245
vector245:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $245
  10281f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102824:	e9 78 00 00 00       	jmp    1028a1 <__alltraps>

00102829 <vector246>:
.globl vector246
vector246:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $246
  10282b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102830:	e9 6c 00 00 00       	jmp    1028a1 <__alltraps>

00102835 <vector247>:
.globl vector247
vector247:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $247
  102837:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10283c:	e9 60 00 00 00       	jmp    1028a1 <__alltraps>

00102841 <vector248>:
.globl vector248
vector248:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $248
  102843:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102848:	e9 54 00 00 00       	jmp    1028a1 <__alltraps>

0010284d <vector249>:
.globl vector249
vector249:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $249
  10284f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102854:	e9 48 00 00 00       	jmp    1028a1 <__alltraps>

00102859 <vector250>:
.globl vector250
vector250:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $250
  10285b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102860:	e9 3c 00 00 00       	jmp    1028a1 <__alltraps>

00102865 <vector251>:
.globl vector251
vector251:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $251
  102867:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10286c:	e9 30 00 00 00       	jmp    1028a1 <__alltraps>

00102871 <vector252>:
.globl vector252
vector252:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $252
  102873:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102878:	e9 24 00 00 00       	jmp    1028a1 <__alltraps>

0010287d <vector253>:
.globl vector253
vector253:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $253
  10287f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102884:	e9 18 00 00 00       	jmp    1028a1 <__alltraps>

00102889 <vector254>:
.globl vector254
vector254:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $254
  10288b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102890:	e9 0c 00 00 00       	jmp    1028a1 <__alltraps>

00102895 <vector255>:
.globl vector255
vector255:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $255
  102897:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10289c:	e9 00 00 00 00       	jmp    1028a1 <__alltraps>

001028a1 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1028a1:	1e                   	push   %ds
    pushl %es
  1028a2:	06                   	push   %es
    pushl %fs
  1028a3:	0f a0                	push   %fs
    pushl %gs
  1028a5:	0f a8                	push   %gs
    pushal
  1028a7:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1028a8:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1028ad:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1028af:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1028b1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1028b2:	e8 63 f5 ff ff       	call   101e1a <trap>

    # pop the pushed stack pointer
    popl %esp
  1028b7:	5c                   	pop    %esp

001028b8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1028b8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1028b9:	0f a9                	pop    %gs
    popl %fs
  1028bb:	0f a1                	pop    %fs
    popl %es
  1028bd:	07                   	pop    %es
    popl %ds
  1028be:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1028bf:	83 c4 08             	add    $0x8,%esp
    iret
  1028c2:	cf                   	iret   

001028c3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028c3:	55                   	push   %ebp
  1028c4:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c9:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1028cf:	29 d0                	sub    %edx,%eax
  1028d1:	c1 f8 02             	sar    $0x2,%eax
  1028d4:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028da:	5d                   	pop    %ebp
  1028db:	c3                   	ret    

001028dc <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028dc:	55                   	push   %ebp
  1028dd:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  1028df:	ff 75 08             	pushl  0x8(%ebp)
  1028e2:	e8 dc ff ff ff       	call   1028c3 <page2ppn>
  1028e7:	83 c4 04             	add    $0x4,%esp
  1028ea:	c1 e0 0c             	shl    $0xc,%eax
}
  1028ed:	c9                   	leave  
  1028ee:	c3                   	ret    

001028ef <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1028ef:	55                   	push   %ebp
  1028f0:	89 e5                	mov    %esp,%ebp
  1028f2:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  1028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f8:	c1 e8 0c             	shr    $0xc,%eax
  1028fb:	89 c2                	mov    %eax,%edx
  1028fd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102902:	39 c2                	cmp    %eax,%edx
  102904:	72 14                	jb     10291a <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  102906:	83 ec 04             	sub    $0x4,%esp
  102909:	68 10 60 10 00       	push   $0x106010
  10290e:	6a 5a                	push   $0x5a
  102910:	68 2f 60 10 00       	push   $0x10602f
  102915:	e8 b8 da ff ff       	call   1003d2 <__panic>
    }
    return &pages[PPN(pa)];
  10291a:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102920:	8b 45 08             	mov    0x8(%ebp),%eax
  102923:	c1 e8 0c             	shr    $0xc,%eax
  102926:	89 c2                	mov    %eax,%edx
  102928:	89 d0                	mov    %edx,%eax
  10292a:	c1 e0 02             	shl    $0x2,%eax
  10292d:	01 d0                	add    %edx,%eax
  10292f:	c1 e0 02             	shl    $0x2,%eax
  102932:	01 c8                	add    %ecx,%eax
}
  102934:	c9                   	leave  
  102935:	c3                   	ret    

00102936 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102936:	55                   	push   %ebp
  102937:	89 e5                	mov    %esp,%ebp
  102939:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  10293c:	ff 75 08             	pushl  0x8(%ebp)
  10293f:	e8 98 ff ff ff       	call   1028dc <page2pa>
  102944:	83 c4 04             	add    $0x4,%esp
  102947:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10294d:	c1 e8 0c             	shr    $0xc,%eax
  102950:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102953:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102958:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10295b:	72 14                	jb     102971 <page2kva+0x3b>
  10295d:	ff 75 f4             	pushl  -0xc(%ebp)
  102960:	68 40 60 10 00       	push   $0x106040
  102965:	6a 61                	push   $0x61
  102967:	68 2f 60 10 00       	push   $0x10602f
  10296c:	e8 61 da ff ff       	call   1003d2 <__panic>
  102971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102974:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102979:	c9                   	leave  
  10297a:	c3                   	ret    

0010297b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  10297b:	55                   	push   %ebp
  10297c:	89 e5                	mov    %esp,%ebp
  10297e:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  102981:	8b 45 08             	mov    0x8(%ebp),%eax
  102984:	83 e0 01             	and    $0x1,%eax
  102987:	85 c0                	test   %eax,%eax
  102989:	75 14                	jne    10299f <pte2page+0x24>
        panic("pte2page called with invalid pte");
  10298b:	83 ec 04             	sub    $0x4,%esp
  10298e:	68 64 60 10 00       	push   $0x106064
  102993:	6a 6c                	push   $0x6c
  102995:	68 2f 60 10 00       	push   $0x10602f
  10299a:	e8 33 da ff ff       	call   1003d2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  10299f:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1029a7:	83 ec 0c             	sub    $0xc,%esp
  1029aa:	50                   	push   %eax
  1029ab:	e8 3f ff ff ff       	call   1028ef <pa2page>
  1029b0:	83 c4 10             	add    $0x10,%esp
}
  1029b3:	c9                   	leave  
  1029b4:	c3                   	ret    

001029b5 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  1029b5:	55                   	push   %ebp
  1029b6:	89 e5                	mov    %esp,%ebp
  1029b8:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  1029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1029c3:	83 ec 0c             	sub    $0xc,%esp
  1029c6:	50                   	push   %eax
  1029c7:	e8 23 ff ff ff       	call   1028ef <pa2page>
  1029cc:	83 c4 10             	add    $0x10,%esp
}
  1029cf:	c9                   	leave  
  1029d0:	c3                   	ret    

001029d1 <page_ref>:

static inline int
page_ref(struct Page *page) {
  1029d1:	55                   	push   %ebp
  1029d2:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d7:	8b 00                	mov    (%eax),%eax
}
  1029d9:	5d                   	pop    %ebp
  1029da:	c3                   	ret    

001029db <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  1029db:	55                   	push   %ebp
  1029dc:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1029de:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e1:	8b 00                	mov    (%eax),%eax
  1029e3:	8d 50 01             	lea    0x1(%eax),%edx
  1029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e9:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ee:	8b 00                	mov    (%eax),%eax
}
  1029f0:	5d                   	pop    %ebp
  1029f1:	c3                   	ret    

001029f2 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1029f2:	55                   	push   %ebp
  1029f3:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f8:	8b 00                	mov    (%eax),%eax
  1029fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  102a00:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a02:	8b 45 08             	mov    0x8(%ebp),%eax
  102a05:	8b 00                	mov    (%eax),%eax
}
  102a07:	5d                   	pop    %ebp
  102a08:	c3                   	ret    

00102a09 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  102a09:	55                   	push   %ebp
  102a0a:	89 e5                	mov    %esp,%ebp
  102a0c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102a0f:	9c                   	pushf  
  102a10:	58                   	pop    %eax
  102a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102a17:	25 00 02 00 00       	and    $0x200,%eax
  102a1c:	85 c0                	test   %eax,%eax
  102a1e:	74 0c                	je     102a2c <__intr_save+0x23>
        intr_disable();
  102a20:	e8 47 ee ff ff       	call   10186c <intr_disable>
        return 1;
  102a25:	b8 01 00 00 00       	mov    $0x1,%eax
  102a2a:	eb 05                	jmp    102a31 <__intr_save+0x28>
    }
    return 0;
  102a2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a31:	c9                   	leave  
  102a32:	c3                   	ret    

00102a33 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102a33:	55                   	push   %ebp
  102a34:	89 e5                	mov    %esp,%ebp
  102a36:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102a39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a3d:	74 05                	je     102a44 <__intr_restore+0x11>
        intr_enable();
  102a3f:	e8 21 ee ff ff       	call   101865 <intr_enable>
    }
}
  102a44:	90                   	nop
  102a45:	c9                   	leave  
  102a46:	c3                   	ret    

00102a47 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a47:	55                   	push   %ebp
  102a48:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4d:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a50:	b8 23 00 00 00       	mov    $0x23,%eax
  102a55:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a57:	b8 23 00 00 00       	mov    $0x23,%eax
  102a5c:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a5e:	b8 10 00 00 00       	mov    $0x10,%eax
  102a63:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a65:	b8 10 00 00 00       	mov    $0x10,%eax
  102a6a:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a6c:	b8 10 00 00 00       	mov    $0x10,%eax
  102a71:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a73:	ea 7a 2a 10 00 08 00 	ljmp   $0x8,$0x102a7a
}
  102a7a:	90                   	nop
  102a7b:	5d                   	pop    %ebp
  102a7c:	c3                   	ret    

00102a7d <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a7d:	55                   	push   %ebp
  102a7e:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a80:	8b 45 08             	mov    0x8(%ebp),%eax
  102a83:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102a88:	90                   	nop
  102a89:	5d                   	pop    %ebp
  102a8a:	c3                   	ret    

00102a8b <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a8b:	55                   	push   %ebp
  102a8c:	89 e5                	mov    %esp,%ebp
  102a8e:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a91:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a96:	50                   	push   %eax
  102a97:	e8 e1 ff ff ff       	call   102a7d <load_esp0>
  102a9c:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102a9f:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102aa6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102aa8:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102aaf:	68 00 
  102ab1:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102ab6:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102abc:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102ac1:	c1 e8 10             	shr    $0x10,%eax
  102ac4:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102ac9:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ad0:	83 e0 f0             	and    $0xfffffff0,%eax
  102ad3:	83 c8 09             	or     $0x9,%eax
  102ad6:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102adb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ae2:	83 e0 ef             	and    $0xffffffef,%eax
  102ae5:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102aea:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102af1:	83 e0 9f             	and    $0xffffff9f,%eax
  102af4:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102af9:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102b00:	83 c8 80             	or     $0xffffff80,%eax
  102b03:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102b08:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b0f:	83 e0 f0             	and    $0xfffffff0,%eax
  102b12:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b17:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b1e:	83 e0 ef             	and    $0xffffffef,%eax
  102b21:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b26:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b2d:	83 e0 df             	and    $0xffffffdf,%eax
  102b30:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b35:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b3c:	83 c8 40             	or     $0x40,%eax
  102b3f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b44:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b4b:	83 e0 7f             	and    $0x7f,%eax
  102b4e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b53:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b58:	c1 e8 18             	shr    $0x18,%eax
  102b5b:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102b60:	68 30 7a 11 00       	push   $0x117a30
  102b65:	e8 dd fe ff ff       	call   102a47 <lgdt>
  102b6a:	83 c4 04             	add    $0x4,%esp
  102b6d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102b73:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b77:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b7a:	90                   	nop
  102b7b:	c9                   	leave  
  102b7c:	c3                   	ret    

00102b7d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b7d:	55                   	push   %ebp
  102b7e:	89 e5                	mov    %esp,%ebp
  102b80:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102b83:	c7 05 50 89 11 00 d8 	movl   $0x1069d8,0x118950
  102b8a:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b8d:	a1 50 89 11 00       	mov    0x118950,%eax
  102b92:	8b 00                	mov    (%eax),%eax
  102b94:	83 ec 08             	sub    $0x8,%esp
  102b97:	50                   	push   %eax
  102b98:	68 90 60 10 00       	push   $0x106090
  102b9d:	e8 ca d6 ff ff       	call   10026c <cprintf>
  102ba2:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102ba5:	a1 50 89 11 00       	mov    0x118950,%eax
  102baa:	8b 40 04             	mov    0x4(%eax),%eax
  102bad:	ff d0                	call   *%eax
}
  102baf:	90                   	nop
  102bb0:	c9                   	leave  
  102bb1:	c3                   	ret    

00102bb2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102bb2:	55                   	push   %ebp
  102bb3:	89 e5                	mov    %esp,%ebp
  102bb5:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102bb8:	a1 50 89 11 00       	mov    0x118950,%eax
  102bbd:	8b 40 08             	mov    0x8(%eax),%eax
  102bc0:	83 ec 08             	sub    $0x8,%esp
  102bc3:	ff 75 0c             	pushl  0xc(%ebp)
  102bc6:	ff 75 08             	pushl  0x8(%ebp)
  102bc9:	ff d0                	call   *%eax
  102bcb:	83 c4 10             	add    $0x10,%esp
}
  102bce:	90                   	nop
  102bcf:	c9                   	leave  
  102bd0:	c3                   	ret    

00102bd1 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102bd1:	55                   	push   %ebp
  102bd2:	89 e5                	mov    %esp,%ebp
  102bd4:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102bd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102bde:	e8 26 fe ff ff       	call   102a09 <__intr_save>
  102be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102be6:	a1 50 89 11 00       	mov    0x118950,%eax
  102beb:	8b 40 0c             	mov    0xc(%eax),%eax
  102bee:	83 ec 0c             	sub    $0xc,%esp
  102bf1:	ff 75 08             	pushl  0x8(%ebp)
  102bf4:	ff d0                	call   *%eax
  102bf6:	83 c4 10             	add    $0x10,%esp
  102bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102bfc:	83 ec 0c             	sub    $0xc,%esp
  102bff:	ff 75 f0             	pushl  -0x10(%ebp)
  102c02:	e8 2c fe ff ff       	call   102a33 <__intr_restore>
  102c07:	83 c4 10             	add    $0x10,%esp
    return page;
  102c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c0d:	c9                   	leave  
  102c0e:	c3                   	ret    

00102c0f <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102c0f:	55                   	push   %ebp
  102c10:	89 e5                	mov    %esp,%ebp
  102c12:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102c15:	e8 ef fd ff ff       	call   102a09 <__intr_save>
  102c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102c1d:	a1 50 89 11 00       	mov    0x118950,%eax
  102c22:	8b 40 10             	mov    0x10(%eax),%eax
  102c25:	83 ec 08             	sub    $0x8,%esp
  102c28:	ff 75 0c             	pushl  0xc(%ebp)
  102c2b:	ff 75 08             	pushl  0x8(%ebp)
  102c2e:	ff d0                	call   *%eax
  102c30:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102c33:	83 ec 0c             	sub    $0xc,%esp
  102c36:	ff 75 f4             	pushl  -0xc(%ebp)
  102c39:	e8 f5 fd ff ff       	call   102a33 <__intr_restore>
  102c3e:	83 c4 10             	add    $0x10,%esp
}
  102c41:	90                   	nop
  102c42:	c9                   	leave  
  102c43:	c3                   	ret    

00102c44 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102c44:	55                   	push   %ebp
  102c45:	89 e5                	mov    %esp,%ebp
  102c47:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102c4a:	e8 ba fd ff ff       	call   102a09 <__intr_save>
  102c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102c52:	a1 50 89 11 00       	mov    0x118950,%eax
  102c57:	8b 40 14             	mov    0x14(%eax),%eax
  102c5a:	ff d0                	call   *%eax
  102c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102c5f:	83 ec 0c             	sub    $0xc,%esp
  102c62:	ff 75 f4             	pushl  -0xc(%ebp)
  102c65:	e8 c9 fd ff ff       	call   102a33 <__intr_restore>
  102c6a:	83 c4 10             	add    $0x10,%esp
    return ret;
  102c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c70:	c9                   	leave  
  102c71:	c3                   	ret    

00102c72 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102c72:	55                   	push   %ebp
  102c73:	89 e5                	mov    %esp,%ebp
  102c75:	57                   	push   %edi
  102c76:	56                   	push   %esi
  102c77:	53                   	push   %ebx
  102c78:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102c7b:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c90:	83 ec 0c             	sub    $0xc,%esp
  102c93:	68 a7 60 10 00       	push   $0x1060a7
  102c98:	e8 cf d5 ff ff       	call   10026c <cprintf>
  102c9d:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102ca0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ca7:	e9 fc 00 00 00       	jmp    102da8 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102cac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102caf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cb2:	89 d0                	mov    %edx,%eax
  102cb4:	c1 e0 02             	shl    $0x2,%eax
  102cb7:	01 d0                	add    %edx,%eax
  102cb9:	c1 e0 02             	shl    $0x2,%eax
  102cbc:	01 c8                	add    %ecx,%eax
  102cbe:	8b 50 08             	mov    0x8(%eax),%edx
  102cc1:	8b 40 04             	mov    0x4(%eax),%eax
  102cc4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102cc7:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102cca:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ccd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cd0:	89 d0                	mov    %edx,%eax
  102cd2:	c1 e0 02             	shl    $0x2,%eax
  102cd5:	01 d0                	add    %edx,%eax
  102cd7:	c1 e0 02             	shl    $0x2,%eax
  102cda:	01 c8                	add    %ecx,%eax
  102cdc:	8b 48 0c             	mov    0xc(%eax),%ecx
  102cdf:	8b 58 10             	mov    0x10(%eax),%ebx
  102ce2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ce5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ce8:	01 c8                	add    %ecx,%eax
  102cea:	11 da                	adc    %ebx,%edx
  102cec:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102cef:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102cf2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cf5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cf8:	89 d0                	mov    %edx,%eax
  102cfa:	c1 e0 02             	shl    $0x2,%eax
  102cfd:	01 d0                	add    %edx,%eax
  102cff:	c1 e0 02             	shl    $0x2,%eax
  102d02:	01 c8                	add    %ecx,%eax
  102d04:	83 c0 14             	add    $0x14,%eax
  102d07:	8b 00                	mov    (%eax),%eax
  102d09:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102d0c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d0f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d12:	83 c0 ff             	add    $0xffffffff,%eax
  102d15:	83 d2 ff             	adc    $0xffffffff,%edx
  102d18:	89 c1                	mov    %eax,%ecx
  102d1a:	89 d3                	mov    %edx,%ebx
  102d1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d1f:	89 55 80             	mov    %edx,-0x80(%ebp)
  102d22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d25:	89 d0                	mov    %edx,%eax
  102d27:	c1 e0 02             	shl    $0x2,%eax
  102d2a:	01 d0                	add    %edx,%eax
  102d2c:	c1 e0 02             	shl    $0x2,%eax
  102d2f:	03 45 80             	add    -0x80(%ebp),%eax
  102d32:	8b 50 10             	mov    0x10(%eax),%edx
  102d35:	8b 40 0c             	mov    0xc(%eax),%eax
  102d38:	ff 75 84             	pushl  -0x7c(%ebp)
  102d3b:	53                   	push   %ebx
  102d3c:	51                   	push   %ecx
  102d3d:	ff 75 bc             	pushl  -0x44(%ebp)
  102d40:	ff 75 b8             	pushl  -0x48(%ebp)
  102d43:	52                   	push   %edx
  102d44:	50                   	push   %eax
  102d45:	68 b4 60 10 00       	push   $0x1060b4
  102d4a:	e8 1d d5 ff ff       	call   10026c <cprintf>
  102d4f:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102d52:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d58:	89 d0                	mov    %edx,%eax
  102d5a:	c1 e0 02             	shl    $0x2,%eax
  102d5d:	01 d0                	add    %edx,%eax
  102d5f:	c1 e0 02             	shl    $0x2,%eax
  102d62:	01 c8                	add    %ecx,%eax
  102d64:	83 c0 14             	add    $0x14,%eax
  102d67:	8b 00                	mov    (%eax),%eax
  102d69:	83 f8 01             	cmp    $0x1,%eax
  102d6c:	75 36                	jne    102da4 <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d74:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d77:	77 2b                	ja     102da4 <page_init+0x132>
  102d79:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d7c:	72 05                	jb     102d83 <page_init+0x111>
  102d7e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102d81:	73 21                	jae    102da4 <page_init+0x132>
  102d83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d87:	77 1b                	ja     102da4 <page_init+0x132>
  102d89:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d8d:	72 09                	jb     102d98 <page_init+0x126>
  102d8f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102d96:	77 0c                	ja     102da4 <page_init+0x132>
                maxpa = end;
  102d98:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d9b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102da1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102da4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102da8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102dab:	8b 00                	mov    (%eax),%eax
  102dad:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102db0:	0f 8f f6 fe ff ff    	jg     102cac <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102db6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dba:	72 1d                	jb     102dd9 <page_init+0x167>
  102dbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102dc0:	77 09                	ja     102dcb <page_init+0x159>
  102dc2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102dc9:	76 0e                	jbe    102dd9 <page_init+0x167>
        maxpa = KMEMSIZE;
  102dcb:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102dd2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ddc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ddf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102de3:	c1 ea 0c             	shr    $0xc,%edx
  102de6:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102deb:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102df2:	b8 68 89 11 00       	mov    $0x118968,%eax
  102df7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dfa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dfd:	01 d0                	add    %edx,%eax
  102dff:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102e02:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e05:	ba 00 00 00 00       	mov    $0x0,%edx
  102e0a:	f7 75 ac             	divl   -0x54(%ebp)
  102e0d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102e10:	29 d0                	sub    %edx,%eax
  102e12:	a3 58 89 11 00       	mov    %eax,0x118958

    for (i = 0; i < npage; i ++) {
  102e17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e1e:	eb 2f                	jmp    102e4f <page_init+0x1dd>
        SetPageReserved(pages + i);
  102e20:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102e26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e29:	89 d0                	mov    %edx,%eax
  102e2b:	c1 e0 02             	shl    $0x2,%eax
  102e2e:	01 d0                	add    %edx,%eax
  102e30:	c1 e0 02             	shl    $0x2,%eax
  102e33:	01 c8                	add    %ecx,%eax
  102e35:	83 c0 04             	add    $0x4,%eax
  102e38:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102e3f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e42:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e45:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e48:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102e4b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e52:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102e57:	39 c2                	cmp    %eax,%edx
  102e59:	72 c5                	jb     102e20 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102e5b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102e61:	89 d0                	mov    %edx,%eax
  102e63:	c1 e0 02             	shl    $0x2,%eax
  102e66:	01 d0                	add    %edx,%eax
  102e68:	c1 e0 02             	shl    $0x2,%eax
  102e6b:	89 c2                	mov    %eax,%edx
  102e6d:	a1 58 89 11 00       	mov    0x118958,%eax
  102e72:	01 d0                	add    %edx,%eax
  102e74:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102e77:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102e7e:	77 17                	ja     102e97 <page_init+0x225>
  102e80:	ff 75 a4             	pushl  -0x5c(%ebp)
  102e83:	68 e4 60 10 00       	push   $0x1060e4
  102e88:	68 db 00 00 00       	push   $0xdb
  102e8d:	68 08 61 10 00       	push   $0x106108
  102e92:	e8 3b d5 ff ff       	call   1003d2 <__panic>
  102e97:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e9a:	05 00 00 00 40       	add    $0x40000000,%eax
  102e9f:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102ea2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ea9:	e9 69 01 00 00       	jmp    103017 <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102eae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eb4:	89 d0                	mov    %edx,%eax
  102eb6:	c1 e0 02             	shl    $0x2,%eax
  102eb9:	01 d0                	add    %edx,%eax
  102ebb:	c1 e0 02             	shl    $0x2,%eax
  102ebe:	01 c8                	add    %ecx,%eax
  102ec0:	8b 50 08             	mov    0x8(%eax),%edx
  102ec3:	8b 40 04             	mov    0x4(%eax),%eax
  102ec6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ec9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ecc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ecf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ed2:	89 d0                	mov    %edx,%eax
  102ed4:	c1 e0 02             	shl    $0x2,%eax
  102ed7:	01 d0                	add    %edx,%eax
  102ed9:	c1 e0 02             	shl    $0x2,%eax
  102edc:	01 c8                	add    %ecx,%eax
  102ede:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ee1:	8b 58 10             	mov    0x10(%eax),%ebx
  102ee4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ee7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102eea:	01 c8                	add    %ecx,%eax
  102eec:	11 da                	adc    %ebx,%edx
  102eee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ef1:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102ef4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ef7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102efa:	89 d0                	mov    %edx,%eax
  102efc:	c1 e0 02             	shl    $0x2,%eax
  102eff:	01 d0                	add    %edx,%eax
  102f01:	c1 e0 02             	shl    $0x2,%eax
  102f04:	01 c8                	add    %ecx,%eax
  102f06:	83 c0 14             	add    $0x14,%eax
  102f09:	8b 00                	mov    (%eax),%eax
  102f0b:	83 f8 01             	cmp    $0x1,%eax
  102f0e:	0f 85 ff 00 00 00    	jne    103013 <page_init+0x3a1>
            if (begin < freemem) {
  102f14:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f17:	ba 00 00 00 00       	mov    $0x0,%edx
  102f1c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f1f:	72 17                	jb     102f38 <page_init+0x2c6>
  102f21:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f24:	77 05                	ja     102f2b <page_init+0x2b9>
  102f26:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f29:	76 0d                	jbe    102f38 <page_init+0x2c6>
                begin = freemem;
  102f2b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f31:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102f38:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f3c:	72 1d                	jb     102f5b <page_init+0x2e9>
  102f3e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f42:	77 09                	ja     102f4d <page_init+0x2db>
  102f44:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102f4b:	76 0e                	jbe    102f5b <page_init+0x2e9>
                end = KMEMSIZE;
  102f4d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102f54:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102f5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f61:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f64:	0f 87 a9 00 00 00    	ja     103013 <page_init+0x3a1>
  102f6a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f6d:	72 09                	jb     102f78 <page_init+0x306>
  102f6f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f72:	0f 83 9b 00 00 00    	jae    103013 <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  102f78:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102f7f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f82:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f85:	01 d0                	add    %edx,%eax
  102f87:	83 e8 01             	sub    $0x1,%eax
  102f8a:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f8d:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f90:	ba 00 00 00 00       	mov    $0x0,%edx
  102f95:	f7 75 9c             	divl   -0x64(%ebp)
  102f98:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f9b:	29 d0                	sub    %edx,%eax
  102f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fa5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102fa8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fab:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102fae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb6:	89 c3                	mov    %eax,%ebx
  102fb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102fbe:	89 de                	mov    %ebx,%esi
  102fc0:	89 d0                	mov    %edx,%eax
  102fc2:	83 e0 00             	and    $0x0,%eax
  102fc5:	89 c7                	mov    %eax,%edi
  102fc7:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102fca:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102fcd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fd0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fd3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fd6:	77 3b                	ja     103013 <page_init+0x3a1>
  102fd8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fdb:	72 05                	jb     102fe2 <page_init+0x370>
  102fdd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102fe0:	73 31                	jae    103013 <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102fe2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fe5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102fe8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102feb:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102fee:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102ff2:	c1 ea 0c             	shr    $0xc,%edx
  102ff5:	89 c3                	mov    %eax,%ebx
  102ff7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ffa:	83 ec 0c             	sub    $0xc,%esp
  102ffd:	50                   	push   %eax
  102ffe:	e8 ec f8 ff ff       	call   1028ef <pa2page>
  103003:	83 c4 10             	add    $0x10,%esp
  103006:	83 ec 08             	sub    $0x8,%esp
  103009:	53                   	push   %ebx
  10300a:	50                   	push   %eax
  10300b:	e8 a2 fb ff ff       	call   102bb2 <init_memmap>
  103010:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  103013:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103017:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10301a:	8b 00                	mov    (%eax),%eax
  10301c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10301f:	0f 8f 89 fe ff ff    	jg     102eae <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  103025:	90                   	nop
  103026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103029:	5b                   	pop    %ebx
  10302a:	5e                   	pop    %esi
  10302b:	5f                   	pop    %edi
  10302c:	5d                   	pop    %ebp
  10302d:	c3                   	ret    

0010302e <enable_paging>:

static void
enable_paging(void) {
  10302e:	55                   	push   %ebp
  10302f:	89 e5                	mov    %esp,%ebp
  103031:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103034:	a1 54 89 11 00       	mov    0x118954,%eax
  103039:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10303c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10303f:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103042:	0f 20 c0             	mov    %cr0,%eax
  103045:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103048:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10304b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10304e:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103055:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  103059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103062:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103065:	90                   	nop
  103066:	c9                   	leave  
  103067:	c3                   	ret    

00103068 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103068:	55                   	push   %ebp
  103069:	89 e5                	mov    %esp,%ebp
  10306b:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10306e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103071:	33 45 14             	xor    0x14(%ebp),%eax
  103074:	25 ff 0f 00 00       	and    $0xfff,%eax
  103079:	85 c0                	test   %eax,%eax
  10307b:	74 19                	je     103096 <boot_map_segment+0x2e>
  10307d:	68 16 61 10 00       	push   $0x106116
  103082:	68 2d 61 10 00       	push   $0x10612d
  103087:	68 04 01 00 00       	push   $0x104
  10308c:	68 08 61 10 00       	push   $0x106108
  103091:	e8 3c d3 ff ff       	call   1003d2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103096:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10309d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a0:	25 ff 0f 00 00       	and    $0xfff,%eax
  1030a5:	89 c2                	mov    %eax,%edx
  1030a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1030aa:	01 c2                	add    %eax,%edx
  1030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030af:	01 d0                	add    %edx,%eax
  1030b1:	83 e8 01             	sub    $0x1,%eax
  1030b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1030bf:	f7 75 f0             	divl   -0x10(%ebp)
  1030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030c5:	29 d0                	sub    %edx,%eax
  1030c7:	c1 e8 0c             	shr    $0xc,%eax
  1030ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1030cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030db:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1030de:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030ec:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030ef:	eb 57                	jmp    103148 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1030f1:	83 ec 04             	sub    $0x4,%esp
  1030f4:	6a 01                	push   $0x1
  1030f6:	ff 75 0c             	pushl  0xc(%ebp)
  1030f9:	ff 75 08             	pushl  0x8(%ebp)
  1030fc:	e8 98 01 00 00       	call   103299 <get_pte>
  103101:	83 c4 10             	add    $0x10,%esp
  103104:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103107:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10310b:	75 19                	jne    103126 <boot_map_segment+0xbe>
  10310d:	68 42 61 10 00       	push   $0x106142
  103112:	68 2d 61 10 00       	push   $0x10612d
  103117:	68 0a 01 00 00       	push   $0x10a
  10311c:	68 08 61 10 00       	push   $0x106108
  103121:	e8 ac d2 ff ff       	call   1003d2 <__panic>
        *ptep = pa | PTE_P | perm;
  103126:	8b 45 14             	mov    0x14(%ebp),%eax
  103129:	0b 45 18             	or     0x18(%ebp),%eax
  10312c:	83 c8 01             	or     $0x1,%eax
  10312f:	89 c2                	mov    %eax,%edx
  103131:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103134:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103136:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10313a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103141:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103148:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10314c:	75 a3                	jne    1030f1 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10314e:	90                   	nop
  10314f:	c9                   	leave  
  103150:	c3                   	ret    

00103151 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103151:	55                   	push   %ebp
  103152:	89 e5                	mov    %esp,%ebp
  103154:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  103157:	83 ec 0c             	sub    $0xc,%esp
  10315a:	6a 01                	push   $0x1
  10315c:	e8 70 fa ff ff       	call   102bd1 <alloc_pages>
  103161:	83 c4 10             	add    $0x10,%esp
  103164:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10316b:	75 17                	jne    103184 <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  10316d:	83 ec 04             	sub    $0x4,%esp
  103170:	68 4f 61 10 00       	push   $0x10614f
  103175:	68 16 01 00 00       	push   $0x116
  10317a:	68 08 61 10 00       	push   $0x106108
  10317f:	e8 4e d2 ff ff       	call   1003d2 <__panic>
    }
    return page2kva(p);
  103184:	83 ec 0c             	sub    $0xc,%esp
  103187:	ff 75 f4             	pushl  -0xc(%ebp)
  10318a:	e8 a7 f7 ff ff       	call   102936 <page2kva>
  10318f:	83 c4 10             	add    $0x10,%esp
}
  103192:	c9                   	leave  
  103193:	c3                   	ret    

00103194 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103194:	55                   	push   %ebp
  103195:	89 e5                	mov    %esp,%ebp
  103197:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10319a:	e8 de f9 ff ff       	call   102b7d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10319f:	e8 ce fa ff ff       	call   102c72 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1031a4:	e8 85 02 00 00       	call   10342e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1031a9:	e8 a3 ff ff ff       	call   103151 <boot_alloc_page>
  1031ae:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1031b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031b8:	83 ec 04             	sub    $0x4,%esp
  1031bb:	68 00 10 00 00       	push   $0x1000
  1031c0:	6a 00                	push   $0x0
  1031c2:	50                   	push   %eax
  1031c3:	e8 6d 1f 00 00       	call   105135 <memset>
  1031c8:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1031cb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031d3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1031da:	77 17                	ja     1031f3 <pmm_init+0x5f>
  1031dc:	ff 75 f4             	pushl  -0xc(%ebp)
  1031df:	68 e4 60 10 00       	push   $0x1060e4
  1031e4:	68 30 01 00 00       	push   $0x130
  1031e9:	68 08 61 10 00       	push   $0x106108
  1031ee:	e8 df d1 ff ff       	call   1003d2 <__panic>
  1031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031f6:	05 00 00 00 40       	add    $0x40000000,%eax
  1031fb:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  103200:	e8 4c 02 00 00       	call   103451 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103205:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10320a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  103210:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103215:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103218:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10321f:	77 17                	ja     103238 <pmm_init+0xa4>
  103221:	ff 75 f0             	pushl  -0x10(%ebp)
  103224:	68 e4 60 10 00       	push   $0x1060e4
  103229:	68 38 01 00 00       	push   $0x138
  10322e:	68 08 61 10 00       	push   $0x106108
  103233:	e8 9a d1 ff ff       	call   1003d2 <__panic>
  103238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10323b:	05 00 00 00 40       	add    $0x40000000,%eax
  103240:	83 c8 03             	or     $0x3,%eax
  103243:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103245:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10324a:	83 ec 0c             	sub    $0xc,%esp
  10324d:	6a 02                	push   $0x2
  10324f:	6a 00                	push   $0x0
  103251:	68 00 00 00 38       	push   $0x38000000
  103256:	68 00 00 00 c0       	push   $0xc0000000
  10325b:	50                   	push   %eax
  10325c:	e8 07 fe ff ff       	call   103068 <boot_map_segment>
  103261:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103264:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103269:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10326f:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103275:	89 10                	mov    %edx,(%eax)

    enable_paging();
  103277:	e8 b2 fd ff ff       	call   10302e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10327c:	e8 0a f8 ff ff       	call   102a8b <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103281:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10328c:	e8 26 07 00 00       	call   1039b7 <check_boot_pgdir>

    print_pgdir();
  103291:	e8 1c 0b 00 00       	call   103db2 <print_pgdir>

}
  103296:	90                   	nop
  103297:	c9                   	leave  
  103298:	c3                   	ret    

00103299 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103299:	55                   	push   %ebp
  10329a:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10329c:	90                   	nop
  10329d:	5d                   	pop    %ebp
  10329e:	c3                   	ret    

0010329f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10329f:	55                   	push   %ebp
  1032a0:	89 e5                	mov    %esp,%ebp
  1032a2:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1032a5:	6a 00                	push   $0x0
  1032a7:	ff 75 0c             	pushl  0xc(%ebp)
  1032aa:	ff 75 08             	pushl  0x8(%ebp)
  1032ad:	e8 e7 ff ff ff       	call   103299 <get_pte>
  1032b2:	83 c4 0c             	add    $0xc,%esp
  1032b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1032b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032bc:	74 08                	je     1032c6 <get_page+0x27>
        *ptep_store = ptep;
  1032be:	8b 45 10             	mov    0x10(%ebp),%eax
  1032c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032c4:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1032c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032ca:	74 1f                	je     1032eb <get_page+0x4c>
  1032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032cf:	8b 00                	mov    (%eax),%eax
  1032d1:	83 e0 01             	and    $0x1,%eax
  1032d4:	85 c0                	test   %eax,%eax
  1032d6:	74 13                	je     1032eb <get_page+0x4c>
        return pte2page(*ptep);
  1032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032db:	8b 00                	mov    (%eax),%eax
  1032dd:	83 ec 0c             	sub    $0xc,%esp
  1032e0:	50                   	push   %eax
  1032e1:	e8 95 f6 ff ff       	call   10297b <pte2page>
  1032e6:	83 c4 10             	add    $0x10,%esp
  1032e9:	eb 05                	jmp    1032f0 <get_page+0x51>
    }
    return NULL;
  1032eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032f0:	c9                   	leave  
  1032f1:	c3                   	ret    

001032f2 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1032f2:	55                   	push   %ebp
  1032f3:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1032f5:	90                   	nop
  1032f6:	5d                   	pop    %ebp
  1032f7:	c3                   	ret    

001032f8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1032f8:	55                   	push   %ebp
  1032f9:	89 e5                	mov    %esp,%ebp
  1032fb:	83 ec 10             	sub    $0x10,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1032fe:	6a 00                	push   $0x0
  103300:	ff 75 0c             	pushl  0xc(%ebp)
  103303:	ff 75 08             	pushl  0x8(%ebp)
  103306:	e8 8e ff ff ff       	call   103299 <get_pte>
  10330b:	83 c4 0c             	add    $0xc,%esp
  10330e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  103311:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103315:	74 11                	je     103328 <page_remove+0x30>
        page_remove_pte(pgdir, la, ptep);
  103317:	ff 75 fc             	pushl  -0x4(%ebp)
  10331a:	ff 75 0c             	pushl  0xc(%ebp)
  10331d:	ff 75 08             	pushl  0x8(%ebp)
  103320:	e8 cd ff ff ff       	call   1032f2 <page_remove_pte>
  103325:	83 c4 0c             	add    $0xc,%esp
    }
}
  103328:	90                   	nop
  103329:	c9                   	leave  
  10332a:	c3                   	ret    

0010332b <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10332b:	55                   	push   %ebp
  10332c:	89 e5                	mov    %esp,%ebp
  10332e:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103331:	6a 01                	push   $0x1
  103333:	ff 75 10             	pushl  0x10(%ebp)
  103336:	ff 75 08             	pushl  0x8(%ebp)
  103339:	e8 5b ff ff ff       	call   103299 <get_pte>
  10333e:	83 c4 0c             	add    $0xc,%esp
  103341:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103348:	75 0a                	jne    103354 <page_insert+0x29>
        return -E_NO_MEM;
  10334a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10334f:	e9 88 00 00 00       	jmp    1033dc <page_insert+0xb1>
    }
    page_ref_inc(page);
  103354:	ff 75 0c             	pushl  0xc(%ebp)
  103357:	e8 7f f6 ff ff       	call   1029db <page_ref_inc>
  10335c:	83 c4 04             	add    $0x4,%esp
    if (*ptep & PTE_P) {
  10335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103362:	8b 00                	mov    (%eax),%eax
  103364:	83 e0 01             	and    $0x1,%eax
  103367:	85 c0                	test   %eax,%eax
  103369:	74 40                	je     1033ab <page_insert+0x80>
        struct Page *p = pte2page(*ptep);
  10336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10336e:	8b 00                	mov    (%eax),%eax
  103370:	83 ec 0c             	sub    $0xc,%esp
  103373:	50                   	push   %eax
  103374:	e8 02 f6 ff ff       	call   10297b <pte2page>
  103379:	83 c4 10             	add    $0x10,%esp
  10337c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103382:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103385:	75 10                	jne    103397 <page_insert+0x6c>
            page_ref_dec(page);
  103387:	83 ec 0c             	sub    $0xc,%esp
  10338a:	ff 75 0c             	pushl  0xc(%ebp)
  10338d:	e8 60 f6 ff ff       	call   1029f2 <page_ref_dec>
  103392:	83 c4 10             	add    $0x10,%esp
  103395:	eb 14                	jmp    1033ab <page_insert+0x80>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103397:	83 ec 04             	sub    $0x4,%esp
  10339a:	ff 75 f4             	pushl  -0xc(%ebp)
  10339d:	ff 75 10             	pushl  0x10(%ebp)
  1033a0:	ff 75 08             	pushl  0x8(%ebp)
  1033a3:	e8 4a ff ff ff       	call   1032f2 <page_remove_pte>
  1033a8:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1033ab:	83 ec 0c             	sub    $0xc,%esp
  1033ae:	ff 75 0c             	pushl  0xc(%ebp)
  1033b1:	e8 26 f5 ff ff       	call   1028dc <page2pa>
  1033b6:	83 c4 10             	add    $0x10,%esp
  1033b9:	0b 45 14             	or     0x14(%ebp),%eax
  1033bc:	83 c8 01             	or     $0x1,%eax
  1033bf:	89 c2                	mov    %eax,%edx
  1033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c4:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1033c6:	83 ec 08             	sub    $0x8,%esp
  1033c9:	ff 75 10             	pushl  0x10(%ebp)
  1033cc:	ff 75 08             	pushl  0x8(%ebp)
  1033cf:	e8 0a 00 00 00       	call   1033de <tlb_invalidate>
  1033d4:	83 c4 10             	add    $0x10,%esp
    return 0;
  1033d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033dc:	c9                   	leave  
  1033dd:	c3                   	ret    

001033de <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1033de:	55                   	push   %ebp
  1033df:	89 e5                	mov    %esp,%ebp
  1033e1:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1033e4:	0f 20 d8             	mov    %cr3,%eax
  1033e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  1033ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1033fa:	77 17                	ja     103413 <tlb_invalidate+0x35>
  1033fc:	ff 75 f0             	pushl  -0x10(%ebp)
  1033ff:	68 e4 60 10 00       	push   $0x1060e4
  103404:	68 d8 01 00 00       	push   $0x1d8
  103409:	68 08 61 10 00       	push   $0x106108
  10340e:	e8 bf cf ff ff       	call   1003d2 <__panic>
  103413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103416:	05 00 00 00 40       	add    $0x40000000,%eax
  10341b:	39 c2                	cmp    %eax,%edx
  10341d:	75 0c                	jne    10342b <tlb_invalidate+0x4d>
        invlpg((void *)la);
  10341f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103422:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103428:	0f 01 38             	invlpg (%eax)
    }
}
  10342b:	90                   	nop
  10342c:	c9                   	leave  
  10342d:	c3                   	ret    

0010342e <check_alloc_page>:

static void
check_alloc_page(void) {
  10342e:	55                   	push   %ebp
  10342f:	89 e5                	mov    %esp,%ebp
  103431:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  103434:	a1 50 89 11 00       	mov    0x118950,%eax
  103439:	8b 40 18             	mov    0x18(%eax),%eax
  10343c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10343e:	83 ec 0c             	sub    $0xc,%esp
  103441:	68 68 61 10 00       	push   $0x106168
  103446:	e8 21 ce ff ff       	call   10026c <cprintf>
  10344b:	83 c4 10             	add    $0x10,%esp
}
  10344e:	90                   	nop
  10344f:	c9                   	leave  
  103450:	c3                   	ret    

00103451 <check_pgdir>:

static void
check_pgdir(void) {
  103451:	55                   	push   %ebp
  103452:	89 e5                	mov    %esp,%ebp
  103454:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103457:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10345c:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103461:	76 19                	jbe    10347c <check_pgdir+0x2b>
  103463:	68 87 61 10 00       	push   $0x106187
  103468:	68 2d 61 10 00       	push   $0x10612d
  10346d:	68 e5 01 00 00       	push   $0x1e5
  103472:	68 08 61 10 00       	push   $0x106108
  103477:	e8 56 cf ff ff       	call   1003d2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10347c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103481:	85 c0                	test   %eax,%eax
  103483:	74 0e                	je     103493 <check_pgdir+0x42>
  103485:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10348a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10348f:	85 c0                	test   %eax,%eax
  103491:	74 19                	je     1034ac <check_pgdir+0x5b>
  103493:	68 a4 61 10 00       	push   $0x1061a4
  103498:	68 2d 61 10 00       	push   $0x10612d
  10349d:	68 e6 01 00 00       	push   $0x1e6
  1034a2:	68 08 61 10 00       	push   $0x106108
  1034a7:	e8 26 cf ff ff       	call   1003d2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1034ac:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1034b1:	83 ec 04             	sub    $0x4,%esp
  1034b4:	6a 00                	push   $0x0
  1034b6:	6a 00                	push   $0x0
  1034b8:	50                   	push   %eax
  1034b9:	e8 e1 fd ff ff       	call   10329f <get_page>
  1034be:	83 c4 10             	add    $0x10,%esp
  1034c1:	85 c0                	test   %eax,%eax
  1034c3:	74 19                	je     1034de <check_pgdir+0x8d>
  1034c5:	68 dc 61 10 00       	push   $0x1061dc
  1034ca:	68 2d 61 10 00       	push   $0x10612d
  1034cf:	68 e7 01 00 00       	push   $0x1e7
  1034d4:	68 08 61 10 00       	push   $0x106108
  1034d9:	e8 f4 ce ff ff       	call   1003d2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1034de:	83 ec 0c             	sub    $0xc,%esp
  1034e1:	6a 01                	push   $0x1
  1034e3:	e8 e9 f6 ff ff       	call   102bd1 <alloc_pages>
  1034e8:	83 c4 10             	add    $0x10,%esp
  1034eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1034ee:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1034f3:	6a 00                	push   $0x0
  1034f5:	6a 00                	push   $0x0
  1034f7:	ff 75 f4             	pushl  -0xc(%ebp)
  1034fa:	50                   	push   %eax
  1034fb:	e8 2b fe ff ff       	call   10332b <page_insert>
  103500:	83 c4 10             	add    $0x10,%esp
  103503:	85 c0                	test   %eax,%eax
  103505:	74 19                	je     103520 <check_pgdir+0xcf>
  103507:	68 04 62 10 00       	push   $0x106204
  10350c:	68 2d 61 10 00       	push   $0x10612d
  103511:	68 eb 01 00 00       	push   $0x1eb
  103516:	68 08 61 10 00       	push   $0x106108
  10351b:	e8 b2 ce ff ff       	call   1003d2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103520:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103525:	83 ec 04             	sub    $0x4,%esp
  103528:	6a 00                	push   $0x0
  10352a:	6a 00                	push   $0x0
  10352c:	50                   	push   %eax
  10352d:	e8 67 fd ff ff       	call   103299 <get_pte>
  103532:	83 c4 10             	add    $0x10,%esp
  103535:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103538:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10353c:	75 19                	jne    103557 <check_pgdir+0x106>
  10353e:	68 30 62 10 00       	push   $0x106230
  103543:	68 2d 61 10 00       	push   $0x10612d
  103548:	68 ee 01 00 00       	push   $0x1ee
  10354d:	68 08 61 10 00       	push   $0x106108
  103552:	e8 7b ce ff ff       	call   1003d2 <__panic>
    assert(pte2page(*ptep) == p1);
  103557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10355a:	8b 00                	mov    (%eax),%eax
  10355c:	83 ec 0c             	sub    $0xc,%esp
  10355f:	50                   	push   %eax
  103560:	e8 16 f4 ff ff       	call   10297b <pte2page>
  103565:	83 c4 10             	add    $0x10,%esp
  103568:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10356b:	74 19                	je     103586 <check_pgdir+0x135>
  10356d:	68 5d 62 10 00       	push   $0x10625d
  103572:	68 2d 61 10 00       	push   $0x10612d
  103577:	68 ef 01 00 00       	push   $0x1ef
  10357c:	68 08 61 10 00       	push   $0x106108
  103581:	e8 4c ce ff ff       	call   1003d2 <__panic>
    assert(page_ref(p1) == 1);
  103586:	83 ec 0c             	sub    $0xc,%esp
  103589:	ff 75 f4             	pushl  -0xc(%ebp)
  10358c:	e8 40 f4 ff ff       	call   1029d1 <page_ref>
  103591:	83 c4 10             	add    $0x10,%esp
  103594:	83 f8 01             	cmp    $0x1,%eax
  103597:	74 19                	je     1035b2 <check_pgdir+0x161>
  103599:	68 73 62 10 00       	push   $0x106273
  10359e:	68 2d 61 10 00       	push   $0x10612d
  1035a3:	68 f0 01 00 00       	push   $0x1f0
  1035a8:	68 08 61 10 00       	push   $0x106108
  1035ad:	e8 20 ce ff ff       	call   1003d2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1035b2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035b7:	8b 00                	mov    (%eax),%eax
  1035b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1035be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c4:	c1 e8 0c             	shr    $0xc,%eax
  1035c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035ca:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1035cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1035d2:	72 17                	jb     1035eb <check_pgdir+0x19a>
  1035d4:	ff 75 ec             	pushl  -0x14(%ebp)
  1035d7:	68 40 60 10 00       	push   $0x106040
  1035dc:	68 f2 01 00 00       	push   $0x1f2
  1035e1:	68 08 61 10 00       	push   $0x106108
  1035e6:	e8 e7 cd ff ff       	call   1003d2 <__panic>
  1035eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035ee:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1035f3:	83 c0 04             	add    $0x4,%eax
  1035f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1035f9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035fe:	83 ec 04             	sub    $0x4,%esp
  103601:	6a 00                	push   $0x0
  103603:	68 00 10 00 00       	push   $0x1000
  103608:	50                   	push   %eax
  103609:	e8 8b fc ff ff       	call   103299 <get_pte>
  10360e:	83 c4 10             	add    $0x10,%esp
  103611:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103614:	74 19                	je     10362f <check_pgdir+0x1de>
  103616:	68 88 62 10 00       	push   $0x106288
  10361b:	68 2d 61 10 00       	push   $0x10612d
  103620:	68 f3 01 00 00       	push   $0x1f3
  103625:	68 08 61 10 00       	push   $0x106108
  10362a:	e8 a3 cd ff ff       	call   1003d2 <__panic>

    p2 = alloc_page();
  10362f:	83 ec 0c             	sub    $0xc,%esp
  103632:	6a 01                	push   $0x1
  103634:	e8 98 f5 ff ff       	call   102bd1 <alloc_pages>
  103639:	83 c4 10             	add    $0x10,%esp
  10363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10363f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103644:	6a 06                	push   $0x6
  103646:	68 00 10 00 00       	push   $0x1000
  10364b:	ff 75 e4             	pushl  -0x1c(%ebp)
  10364e:	50                   	push   %eax
  10364f:	e8 d7 fc ff ff       	call   10332b <page_insert>
  103654:	83 c4 10             	add    $0x10,%esp
  103657:	85 c0                	test   %eax,%eax
  103659:	74 19                	je     103674 <check_pgdir+0x223>
  10365b:	68 b0 62 10 00       	push   $0x1062b0
  103660:	68 2d 61 10 00       	push   $0x10612d
  103665:	68 f6 01 00 00       	push   $0x1f6
  10366a:	68 08 61 10 00       	push   $0x106108
  10366f:	e8 5e cd ff ff       	call   1003d2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103674:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103679:	83 ec 04             	sub    $0x4,%esp
  10367c:	6a 00                	push   $0x0
  10367e:	68 00 10 00 00       	push   $0x1000
  103683:	50                   	push   %eax
  103684:	e8 10 fc ff ff       	call   103299 <get_pte>
  103689:	83 c4 10             	add    $0x10,%esp
  10368c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10368f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103693:	75 19                	jne    1036ae <check_pgdir+0x25d>
  103695:	68 e8 62 10 00       	push   $0x1062e8
  10369a:	68 2d 61 10 00       	push   $0x10612d
  10369f:	68 f7 01 00 00       	push   $0x1f7
  1036a4:	68 08 61 10 00       	push   $0x106108
  1036a9:	e8 24 cd ff ff       	call   1003d2 <__panic>
    assert(*ptep & PTE_U);
  1036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036b1:	8b 00                	mov    (%eax),%eax
  1036b3:	83 e0 04             	and    $0x4,%eax
  1036b6:	85 c0                	test   %eax,%eax
  1036b8:	75 19                	jne    1036d3 <check_pgdir+0x282>
  1036ba:	68 18 63 10 00       	push   $0x106318
  1036bf:	68 2d 61 10 00       	push   $0x10612d
  1036c4:	68 f8 01 00 00       	push   $0x1f8
  1036c9:	68 08 61 10 00       	push   $0x106108
  1036ce:	e8 ff cc ff ff       	call   1003d2 <__panic>
    assert(*ptep & PTE_W);
  1036d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036d6:	8b 00                	mov    (%eax),%eax
  1036d8:	83 e0 02             	and    $0x2,%eax
  1036db:	85 c0                	test   %eax,%eax
  1036dd:	75 19                	jne    1036f8 <check_pgdir+0x2a7>
  1036df:	68 26 63 10 00       	push   $0x106326
  1036e4:	68 2d 61 10 00       	push   $0x10612d
  1036e9:	68 f9 01 00 00       	push   $0x1f9
  1036ee:	68 08 61 10 00       	push   $0x106108
  1036f3:	e8 da cc ff ff       	call   1003d2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  1036f8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036fd:	8b 00                	mov    (%eax),%eax
  1036ff:	83 e0 04             	and    $0x4,%eax
  103702:	85 c0                	test   %eax,%eax
  103704:	75 19                	jne    10371f <check_pgdir+0x2ce>
  103706:	68 34 63 10 00       	push   $0x106334
  10370b:	68 2d 61 10 00       	push   $0x10612d
  103710:	68 fa 01 00 00       	push   $0x1fa
  103715:	68 08 61 10 00       	push   $0x106108
  10371a:	e8 b3 cc ff ff       	call   1003d2 <__panic>
    assert(page_ref(p2) == 1);
  10371f:	83 ec 0c             	sub    $0xc,%esp
  103722:	ff 75 e4             	pushl  -0x1c(%ebp)
  103725:	e8 a7 f2 ff ff       	call   1029d1 <page_ref>
  10372a:	83 c4 10             	add    $0x10,%esp
  10372d:	83 f8 01             	cmp    $0x1,%eax
  103730:	74 19                	je     10374b <check_pgdir+0x2fa>
  103732:	68 4a 63 10 00       	push   $0x10634a
  103737:	68 2d 61 10 00       	push   $0x10612d
  10373c:	68 fb 01 00 00       	push   $0x1fb
  103741:	68 08 61 10 00       	push   $0x106108
  103746:	e8 87 cc ff ff       	call   1003d2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10374b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103750:	6a 00                	push   $0x0
  103752:	68 00 10 00 00       	push   $0x1000
  103757:	ff 75 f4             	pushl  -0xc(%ebp)
  10375a:	50                   	push   %eax
  10375b:	e8 cb fb ff ff       	call   10332b <page_insert>
  103760:	83 c4 10             	add    $0x10,%esp
  103763:	85 c0                	test   %eax,%eax
  103765:	74 19                	je     103780 <check_pgdir+0x32f>
  103767:	68 5c 63 10 00       	push   $0x10635c
  10376c:	68 2d 61 10 00       	push   $0x10612d
  103771:	68 fd 01 00 00       	push   $0x1fd
  103776:	68 08 61 10 00       	push   $0x106108
  10377b:	e8 52 cc ff ff       	call   1003d2 <__panic>
    assert(page_ref(p1) == 2);
  103780:	83 ec 0c             	sub    $0xc,%esp
  103783:	ff 75 f4             	pushl  -0xc(%ebp)
  103786:	e8 46 f2 ff ff       	call   1029d1 <page_ref>
  10378b:	83 c4 10             	add    $0x10,%esp
  10378e:	83 f8 02             	cmp    $0x2,%eax
  103791:	74 19                	je     1037ac <check_pgdir+0x35b>
  103793:	68 88 63 10 00       	push   $0x106388
  103798:	68 2d 61 10 00       	push   $0x10612d
  10379d:	68 fe 01 00 00       	push   $0x1fe
  1037a2:	68 08 61 10 00       	push   $0x106108
  1037a7:	e8 26 cc ff ff       	call   1003d2 <__panic>
    assert(page_ref(p2) == 0);
  1037ac:	83 ec 0c             	sub    $0xc,%esp
  1037af:	ff 75 e4             	pushl  -0x1c(%ebp)
  1037b2:	e8 1a f2 ff ff       	call   1029d1 <page_ref>
  1037b7:	83 c4 10             	add    $0x10,%esp
  1037ba:	85 c0                	test   %eax,%eax
  1037bc:	74 19                	je     1037d7 <check_pgdir+0x386>
  1037be:	68 9a 63 10 00       	push   $0x10639a
  1037c3:	68 2d 61 10 00       	push   $0x10612d
  1037c8:	68 ff 01 00 00       	push   $0x1ff
  1037cd:	68 08 61 10 00       	push   $0x106108
  1037d2:	e8 fb cb ff ff       	call   1003d2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1037d7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037dc:	83 ec 04             	sub    $0x4,%esp
  1037df:	6a 00                	push   $0x0
  1037e1:	68 00 10 00 00       	push   $0x1000
  1037e6:	50                   	push   %eax
  1037e7:	e8 ad fa ff ff       	call   103299 <get_pte>
  1037ec:	83 c4 10             	add    $0x10,%esp
  1037ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037f6:	75 19                	jne    103811 <check_pgdir+0x3c0>
  1037f8:	68 e8 62 10 00       	push   $0x1062e8
  1037fd:	68 2d 61 10 00       	push   $0x10612d
  103802:	68 00 02 00 00       	push   $0x200
  103807:	68 08 61 10 00       	push   $0x106108
  10380c:	e8 c1 cb ff ff       	call   1003d2 <__panic>
    assert(pte2page(*ptep) == p1);
  103811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103814:	8b 00                	mov    (%eax),%eax
  103816:	83 ec 0c             	sub    $0xc,%esp
  103819:	50                   	push   %eax
  10381a:	e8 5c f1 ff ff       	call   10297b <pte2page>
  10381f:	83 c4 10             	add    $0x10,%esp
  103822:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103825:	74 19                	je     103840 <check_pgdir+0x3ef>
  103827:	68 5d 62 10 00       	push   $0x10625d
  10382c:	68 2d 61 10 00       	push   $0x10612d
  103831:	68 01 02 00 00       	push   $0x201
  103836:	68 08 61 10 00       	push   $0x106108
  10383b:	e8 92 cb ff ff       	call   1003d2 <__panic>
    assert((*ptep & PTE_U) == 0);
  103840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103843:	8b 00                	mov    (%eax),%eax
  103845:	83 e0 04             	and    $0x4,%eax
  103848:	85 c0                	test   %eax,%eax
  10384a:	74 19                	je     103865 <check_pgdir+0x414>
  10384c:	68 ac 63 10 00       	push   $0x1063ac
  103851:	68 2d 61 10 00       	push   $0x10612d
  103856:	68 02 02 00 00       	push   $0x202
  10385b:	68 08 61 10 00       	push   $0x106108
  103860:	e8 6d cb ff ff       	call   1003d2 <__panic>

    page_remove(boot_pgdir, 0x0);
  103865:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10386a:	83 ec 08             	sub    $0x8,%esp
  10386d:	6a 00                	push   $0x0
  10386f:	50                   	push   %eax
  103870:	e8 83 fa ff ff       	call   1032f8 <page_remove>
  103875:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  103878:	83 ec 0c             	sub    $0xc,%esp
  10387b:	ff 75 f4             	pushl  -0xc(%ebp)
  10387e:	e8 4e f1 ff ff       	call   1029d1 <page_ref>
  103883:	83 c4 10             	add    $0x10,%esp
  103886:	83 f8 01             	cmp    $0x1,%eax
  103889:	74 19                	je     1038a4 <check_pgdir+0x453>
  10388b:	68 73 62 10 00       	push   $0x106273
  103890:	68 2d 61 10 00       	push   $0x10612d
  103895:	68 05 02 00 00       	push   $0x205
  10389a:	68 08 61 10 00       	push   $0x106108
  10389f:	e8 2e cb ff ff       	call   1003d2 <__panic>
    assert(page_ref(p2) == 0);
  1038a4:	83 ec 0c             	sub    $0xc,%esp
  1038a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  1038aa:	e8 22 f1 ff ff       	call   1029d1 <page_ref>
  1038af:	83 c4 10             	add    $0x10,%esp
  1038b2:	85 c0                	test   %eax,%eax
  1038b4:	74 19                	je     1038cf <check_pgdir+0x47e>
  1038b6:	68 9a 63 10 00       	push   $0x10639a
  1038bb:	68 2d 61 10 00       	push   $0x10612d
  1038c0:	68 06 02 00 00       	push   $0x206
  1038c5:	68 08 61 10 00       	push   $0x106108
  1038ca:	e8 03 cb ff ff       	call   1003d2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1038cf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038d4:	83 ec 08             	sub    $0x8,%esp
  1038d7:	68 00 10 00 00       	push   $0x1000
  1038dc:	50                   	push   %eax
  1038dd:	e8 16 fa ff ff       	call   1032f8 <page_remove>
  1038e2:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  1038e5:	83 ec 0c             	sub    $0xc,%esp
  1038e8:	ff 75 f4             	pushl  -0xc(%ebp)
  1038eb:	e8 e1 f0 ff ff       	call   1029d1 <page_ref>
  1038f0:	83 c4 10             	add    $0x10,%esp
  1038f3:	85 c0                	test   %eax,%eax
  1038f5:	74 19                	je     103910 <check_pgdir+0x4bf>
  1038f7:	68 c1 63 10 00       	push   $0x1063c1
  1038fc:	68 2d 61 10 00       	push   $0x10612d
  103901:	68 09 02 00 00       	push   $0x209
  103906:	68 08 61 10 00       	push   $0x106108
  10390b:	e8 c2 ca ff ff       	call   1003d2 <__panic>
    assert(page_ref(p2) == 0);
  103910:	83 ec 0c             	sub    $0xc,%esp
  103913:	ff 75 e4             	pushl  -0x1c(%ebp)
  103916:	e8 b6 f0 ff ff       	call   1029d1 <page_ref>
  10391b:	83 c4 10             	add    $0x10,%esp
  10391e:	85 c0                	test   %eax,%eax
  103920:	74 19                	je     10393b <check_pgdir+0x4ea>
  103922:	68 9a 63 10 00       	push   $0x10639a
  103927:	68 2d 61 10 00       	push   $0x10612d
  10392c:	68 0a 02 00 00       	push   $0x20a
  103931:	68 08 61 10 00       	push   $0x106108
  103936:	e8 97 ca ff ff       	call   1003d2 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  10393b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103940:	8b 00                	mov    (%eax),%eax
  103942:	83 ec 0c             	sub    $0xc,%esp
  103945:	50                   	push   %eax
  103946:	e8 6a f0 ff ff       	call   1029b5 <pde2page>
  10394b:	83 c4 10             	add    $0x10,%esp
  10394e:	83 ec 0c             	sub    $0xc,%esp
  103951:	50                   	push   %eax
  103952:	e8 7a f0 ff ff       	call   1029d1 <page_ref>
  103957:	83 c4 10             	add    $0x10,%esp
  10395a:	83 f8 01             	cmp    $0x1,%eax
  10395d:	74 19                	je     103978 <check_pgdir+0x527>
  10395f:	68 d4 63 10 00       	push   $0x1063d4
  103964:	68 2d 61 10 00       	push   $0x10612d
  103969:	68 0c 02 00 00       	push   $0x20c
  10396e:	68 08 61 10 00       	push   $0x106108
  103973:	e8 5a ca ff ff       	call   1003d2 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103978:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10397d:	8b 00                	mov    (%eax),%eax
  10397f:	83 ec 0c             	sub    $0xc,%esp
  103982:	50                   	push   %eax
  103983:	e8 2d f0 ff ff       	call   1029b5 <pde2page>
  103988:	83 c4 10             	add    $0x10,%esp
  10398b:	83 ec 08             	sub    $0x8,%esp
  10398e:	6a 01                	push   $0x1
  103990:	50                   	push   %eax
  103991:	e8 79 f2 ff ff       	call   102c0f <free_pages>
  103996:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103999:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10399e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1039a4:	83 ec 0c             	sub    $0xc,%esp
  1039a7:	68 fb 63 10 00       	push   $0x1063fb
  1039ac:	e8 bb c8 ff ff       	call   10026c <cprintf>
  1039b1:	83 c4 10             	add    $0x10,%esp
}
  1039b4:	90                   	nop
  1039b5:	c9                   	leave  
  1039b6:	c3                   	ret    

001039b7 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1039b7:	55                   	push   %ebp
  1039b8:	89 e5                	mov    %esp,%ebp
  1039ba:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1039bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1039c4:	e9 a3 00 00 00       	jmp    103a6c <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039d2:	c1 e8 0c             	shr    $0xc,%eax
  1039d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039d8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039dd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1039e0:	72 17                	jb     1039f9 <check_boot_pgdir+0x42>
  1039e2:	ff 75 f0             	pushl  -0x10(%ebp)
  1039e5:	68 40 60 10 00       	push   $0x106040
  1039ea:	68 18 02 00 00       	push   $0x218
  1039ef:	68 08 61 10 00       	push   $0x106108
  1039f4:	e8 d9 c9 ff ff       	call   1003d2 <__panic>
  1039f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039fc:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103a01:	89 c2                	mov    %eax,%edx
  103a03:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a08:	83 ec 04             	sub    $0x4,%esp
  103a0b:	6a 00                	push   $0x0
  103a0d:	52                   	push   %edx
  103a0e:	50                   	push   %eax
  103a0f:	e8 85 f8 ff ff       	call   103299 <get_pte>
  103a14:	83 c4 10             	add    $0x10,%esp
  103a17:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103a1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103a1e:	75 19                	jne    103a39 <check_boot_pgdir+0x82>
  103a20:	68 18 64 10 00       	push   $0x106418
  103a25:	68 2d 61 10 00       	push   $0x10612d
  103a2a:	68 18 02 00 00       	push   $0x218
  103a2f:	68 08 61 10 00       	push   $0x106108
  103a34:	e8 99 c9 ff ff       	call   1003d2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a3c:	8b 00                	mov    (%eax),%eax
  103a3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a43:	89 c2                	mov    %eax,%edx
  103a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a48:	39 c2                	cmp    %eax,%edx
  103a4a:	74 19                	je     103a65 <check_boot_pgdir+0xae>
  103a4c:	68 55 64 10 00       	push   $0x106455
  103a51:	68 2d 61 10 00       	push   $0x10612d
  103a56:	68 19 02 00 00       	push   $0x219
  103a5b:	68 08 61 10 00       	push   $0x106108
  103a60:	e8 6d c9 ff ff       	call   1003d2 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103a65:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a6f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a74:	39 c2                	cmp    %eax,%edx
  103a76:	0f 82 4d ff ff ff    	jb     1039c9 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103a7c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a81:	05 ac 0f 00 00       	add    $0xfac,%eax
  103a86:	8b 00                	mov    (%eax),%eax
  103a88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a8d:	89 c2                	mov    %eax,%edx
  103a8f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a97:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103a9e:	77 17                	ja     103ab7 <check_boot_pgdir+0x100>
  103aa0:	ff 75 e4             	pushl  -0x1c(%ebp)
  103aa3:	68 e4 60 10 00       	push   $0x1060e4
  103aa8:	68 1c 02 00 00       	push   $0x21c
  103aad:	68 08 61 10 00       	push   $0x106108
  103ab2:	e8 1b c9 ff ff       	call   1003d2 <__panic>
  103ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103aba:	05 00 00 00 40       	add    $0x40000000,%eax
  103abf:	39 c2                	cmp    %eax,%edx
  103ac1:	74 19                	je     103adc <check_boot_pgdir+0x125>
  103ac3:	68 6c 64 10 00       	push   $0x10646c
  103ac8:	68 2d 61 10 00       	push   $0x10612d
  103acd:	68 1c 02 00 00       	push   $0x21c
  103ad2:	68 08 61 10 00       	push   $0x106108
  103ad7:	e8 f6 c8 ff ff       	call   1003d2 <__panic>

    assert(boot_pgdir[0] == 0);
  103adc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ae1:	8b 00                	mov    (%eax),%eax
  103ae3:	85 c0                	test   %eax,%eax
  103ae5:	74 19                	je     103b00 <check_boot_pgdir+0x149>
  103ae7:	68 a0 64 10 00       	push   $0x1064a0
  103aec:	68 2d 61 10 00       	push   $0x10612d
  103af1:	68 1e 02 00 00       	push   $0x21e
  103af6:	68 08 61 10 00       	push   $0x106108
  103afb:	e8 d2 c8 ff ff       	call   1003d2 <__panic>

    struct Page *p;
    p = alloc_page();
  103b00:	83 ec 0c             	sub    $0xc,%esp
  103b03:	6a 01                	push   $0x1
  103b05:	e8 c7 f0 ff ff       	call   102bd1 <alloc_pages>
  103b0a:	83 c4 10             	add    $0x10,%esp
  103b0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103b10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b15:	6a 02                	push   $0x2
  103b17:	68 00 01 00 00       	push   $0x100
  103b1c:	ff 75 e0             	pushl  -0x20(%ebp)
  103b1f:	50                   	push   %eax
  103b20:	e8 06 f8 ff ff       	call   10332b <page_insert>
  103b25:	83 c4 10             	add    $0x10,%esp
  103b28:	85 c0                	test   %eax,%eax
  103b2a:	74 19                	je     103b45 <check_boot_pgdir+0x18e>
  103b2c:	68 b4 64 10 00       	push   $0x1064b4
  103b31:	68 2d 61 10 00       	push   $0x10612d
  103b36:	68 22 02 00 00       	push   $0x222
  103b3b:	68 08 61 10 00       	push   $0x106108
  103b40:	e8 8d c8 ff ff       	call   1003d2 <__panic>
    assert(page_ref(p) == 1);
  103b45:	83 ec 0c             	sub    $0xc,%esp
  103b48:	ff 75 e0             	pushl  -0x20(%ebp)
  103b4b:	e8 81 ee ff ff       	call   1029d1 <page_ref>
  103b50:	83 c4 10             	add    $0x10,%esp
  103b53:	83 f8 01             	cmp    $0x1,%eax
  103b56:	74 19                	je     103b71 <check_boot_pgdir+0x1ba>
  103b58:	68 e2 64 10 00       	push   $0x1064e2
  103b5d:	68 2d 61 10 00       	push   $0x10612d
  103b62:	68 23 02 00 00       	push   $0x223
  103b67:	68 08 61 10 00       	push   $0x106108
  103b6c:	e8 61 c8 ff ff       	call   1003d2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103b71:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b76:	6a 02                	push   $0x2
  103b78:	68 00 11 00 00       	push   $0x1100
  103b7d:	ff 75 e0             	pushl  -0x20(%ebp)
  103b80:	50                   	push   %eax
  103b81:	e8 a5 f7 ff ff       	call   10332b <page_insert>
  103b86:	83 c4 10             	add    $0x10,%esp
  103b89:	85 c0                	test   %eax,%eax
  103b8b:	74 19                	je     103ba6 <check_boot_pgdir+0x1ef>
  103b8d:	68 f4 64 10 00       	push   $0x1064f4
  103b92:	68 2d 61 10 00       	push   $0x10612d
  103b97:	68 24 02 00 00       	push   $0x224
  103b9c:	68 08 61 10 00       	push   $0x106108
  103ba1:	e8 2c c8 ff ff       	call   1003d2 <__panic>
    assert(page_ref(p) == 2);
  103ba6:	83 ec 0c             	sub    $0xc,%esp
  103ba9:	ff 75 e0             	pushl  -0x20(%ebp)
  103bac:	e8 20 ee ff ff       	call   1029d1 <page_ref>
  103bb1:	83 c4 10             	add    $0x10,%esp
  103bb4:	83 f8 02             	cmp    $0x2,%eax
  103bb7:	74 19                	je     103bd2 <check_boot_pgdir+0x21b>
  103bb9:	68 2b 65 10 00       	push   $0x10652b
  103bbe:	68 2d 61 10 00       	push   $0x10612d
  103bc3:	68 25 02 00 00       	push   $0x225
  103bc8:	68 08 61 10 00       	push   $0x106108
  103bcd:	e8 00 c8 ff ff       	call   1003d2 <__panic>

    const char *str = "ucore: Hello world!!";
  103bd2:	c7 45 dc 3c 65 10 00 	movl   $0x10653c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103bd9:	83 ec 08             	sub    $0x8,%esp
  103bdc:	ff 75 dc             	pushl  -0x24(%ebp)
  103bdf:	68 00 01 00 00       	push   $0x100
  103be4:	e8 73 12 00 00       	call   104e5c <strcpy>
  103be9:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103bec:	83 ec 08             	sub    $0x8,%esp
  103bef:	68 00 11 00 00       	push   $0x1100
  103bf4:	68 00 01 00 00       	push   $0x100
  103bf9:	e8 d8 12 00 00       	call   104ed6 <strcmp>
  103bfe:	83 c4 10             	add    $0x10,%esp
  103c01:	85 c0                	test   %eax,%eax
  103c03:	74 19                	je     103c1e <check_boot_pgdir+0x267>
  103c05:	68 54 65 10 00       	push   $0x106554
  103c0a:	68 2d 61 10 00       	push   $0x10612d
  103c0f:	68 29 02 00 00       	push   $0x229
  103c14:	68 08 61 10 00       	push   $0x106108
  103c19:	e8 b4 c7 ff ff       	call   1003d2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103c1e:	83 ec 0c             	sub    $0xc,%esp
  103c21:	ff 75 e0             	pushl  -0x20(%ebp)
  103c24:	e8 0d ed ff ff       	call   102936 <page2kva>
  103c29:	83 c4 10             	add    $0x10,%esp
  103c2c:	05 00 01 00 00       	add    $0x100,%eax
  103c31:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103c34:	83 ec 0c             	sub    $0xc,%esp
  103c37:	68 00 01 00 00       	push   $0x100
  103c3c:	e8 c3 11 00 00       	call   104e04 <strlen>
  103c41:	83 c4 10             	add    $0x10,%esp
  103c44:	85 c0                	test   %eax,%eax
  103c46:	74 19                	je     103c61 <check_boot_pgdir+0x2aa>
  103c48:	68 8c 65 10 00       	push   $0x10658c
  103c4d:	68 2d 61 10 00       	push   $0x10612d
  103c52:	68 2c 02 00 00       	push   $0x22c
  103c57:	68 08 61 10 00       	push   $0x106108
  103c5c:	e8 71 c7 ff ff       	call   1003d2 <__panic>

    free_page(p);
  103c61:	83 ec 08             	sub    $0x8,%esp
  103c64:	6a 01                	push   $0x1
  103c66:	ff 75 e0             	pushl  -0x20(%ebp)
  103c69:	e8 a1 ef ff ff       	call   102c0f <free_pages>
  103c6e:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103c71:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c76:	8b 00                	mov    (%eax),%eax
  103c78:	83 ec 0c             	sub    $0xc,%esp
  103c7b:	50                   	push   %eax
  103c7c:	e8 34 ed ff ff       	call   1029b5 <pde2page>
  103c81:	83 c4 10             	add    $0x10,%esp
  103c84:	83 ec 08             	sub    $0x8,%esp
  103c87:	6a 01                	push   $0x1
  103c89:	50                   	push   %eax
  103c8a:	e8 80 ef ff ff       	call   102c0f <free_pages>
  103c8f:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103c92:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103c9d:	83 ec 0c             	sub    $0xc,%esp
  103ca0:	68 b0 65 10 00       	push   $0x1065b0
  103ca5:	e8 c2 c5 ff ff       	call   10026c <cprintf>
  103caa:	83 c4 10             	add    $0x10,%esp
}
  103cad:	90                   	nop
  103cae:	c9                   	leave  
  103caf:	c3                   	ret    

00103cb0 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103cb0:	55                   	push   %ebp
  103cb1:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  103cb6:	83 e0 04             	and    $0x4,%eax
  103cb9:	85 c0                	test   %eax,%eax
  103cbb:	74 07                	je     103cc4 <perm2str+0x14>
  103cbd:	b8 75 00 00 00       	mov    $0x75,%eax
  103cc2:	eb 05                	jmp    103cc9 <perm2str+0x19>
  103cc4:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103cc9:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103cce:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  103cd8:	83 e0 02             	and    $0x2,%eax
  103cdb:	85 c0                	test   %eax,%eax
  103cdd:	74 07                	je     103ce6 <perm2str+0x36>
  103cdf:	b8 77 00 00 00       	mov    $0x77,%eax
  103ce4:	eb 05                	jmp    103ceb <perm2str+0x3b>
  103ce6:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103ceb:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103cf0:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103cf7:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103cfc:	5d                   	pop    %ebp
  103cfd:	c3                   	ret    

00103cfe <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103cfe:	55                   	push   %ebp
  103cff:	89 e5                	mov    %esp,%ebp
  103d01:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103d04:	8b 45 10             	mov    0x10(%ebp),%eax
  103d07:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d0a:	72 0e                	jb     103d1a <get_pgtable_items+0x1c>
        return 0;
  103d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  103d11:	e9 9a 00 00 00       	jmp    103db0 <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103d16:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  103d1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d20:	73 18                	jae    103d3a <get_pgtable_items+0x3c>
  103d22:	8b 45 10             	mov    0x10(%ebp),%eax
  103d25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  103d2f:	01 d0                	add    %edx,%eax
  103d31:	8b 00                	mov    (%eax),%eax
  103d33:	83 e0 01             	and    $0x1,%eax
  103d36:	85 c0                	test   %eax,%eax
  103d38:	74 dc                	je     103d16 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  103d3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d40:	73 69                	jae    103dab <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103d42:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103d46:	74 08                	je     103d50 <get_pgtable_items+0x52>
            *left_store = start;
  103d48:	8b 45 18             	mov    0x18(%ebp),%eax
  103d4b:	8b 55 10             	mov    0x10(%ebp),%edx
  103d4e:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103d50:	8b 45 10             	mov    0x10(%ebp),%eax
  103d53:	8d 50 01             	lea    0x1(%eax),%edx
  103d56:	89 55 10             	mov    %edx,0x10(%ebp)
  103d59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d60:	8b 45 14             	mov    0x14(%ebp),%eax
  103d63:	01 d0                	add    %edx,%eax
  103d65:	8b 00                	mov    (%eax),%eax
  103d67:	83 e0 07             	and    $0x7,%eax
  103d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d6d:	eb 04                	jmp    103d73 <get_pgtable_items+0x75>
            start ++;
  103d6f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d73:	8b 45 10             	mov    0x10(%ebp),%eax
  103d76:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d79:	73 1d                	jae    103d98 <get_pgtable_items+0x9a>
  103d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  103d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d85:	8b 45 14             	mov    0x14(%ebp),%eax
  103d88:	01 d0                	add    %edx,%eax
  103d8a:	8b 00                	mov    (%eax),%eax
  103d8c:	83 e0 07             	and    $0x7,%eax
  103d8f:	89 c2                	mov    %eax,%edx
  103d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103d94:	39 c2                	cmp    %eax,%edx
  103d96:	74 d7                	je     103d6f <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103d98:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103d9c:	74 08                	je     103da6 <get_pgtable_items+0xa8>
            *right_store = start;
  103d9e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103da1:	8b 55 10             	mov    0x10(%ebp),%edx
  103da4:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103da9:	eb 05                	jmp    103db0 <get_pgtable_items+0xb2>
    }
    return 0;
  103dab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103db0:	c9                   	leave  
  103db1:	c3                   	ret    

00103db2 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103db2:	55                   	push   %ebp
  103db3:	89 e5                	mov    %esp,%ebp
  103db5:	57                   	push   %edi
  103db6:	56                   	push   %esi
  103db7:	53                   	push   %ebx
  103db8:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103dbb:	83 ec 0c             	sub    $0xc,%esp
  103dbe:	68 d0 65 10 00       	push   $0x1065d0
  103dc3:	e8 a4 c4 ff ff       	call   10026c <cprintf>
  103dc8:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  103dcb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103dd2:	e9 e5 00 00 00       	jmp    103ebc <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dda:	83 ec 0c             	sub    $0xc,%esp
  103ddd:	50                   	push   %eax
  103dde:	e8 cd fe ff ff       	call   103cb0 <perm2str>
  103de3:	83 c4 10             	add    $0x10,%esp
  103de6:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103de8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103deb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103dee:	29 c2                	sub    %eax,%edx
  103df0:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103df2:	c1 e0 16             	shl    $0x16,%eax
  103df5:	89 c3                	mov    %eax,%ebx
  103df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103dfa:	c1 e0 16             	shl    $0x16,%eax
  103dfd:	89 c1                	mov    %eax,%ecx
  103dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e02:	c1 e0 16             	shl    $0x16,%eax
  103e05:	89 c2                	mov    %eax,%edx
  103e07:	8b 75 dc             	mov    -0x24(%ebp),%esi
  103e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e0d:	29 c6                	sub    %eax,%esi
  103e0f:	89 f0                	mov    %esi,%eax
  103e11:	83 ec 08             	sub    $0x8,%esp
  103e14:	57                   	push   %edi
  103e15:	53                   	push   %ebx
  103e16:	51                   	push   %ecx
  103e17:	52                   	push   %edx
  103e18:	50                   	push   %eax
  103e19:	68 01 66 10 00       	push   $0x106601
  103e1e:	e8 49 c4 ff ff       	call   10026c <cprintf>
  103e23:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  103e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e29:	c1 e0 0a             	shl    $0xa,%eax
  103e2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103e2f:	eb 4f                	jmp    103e80 <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e34:	83 ec 0c             	sub    $0xc,%esp
  103e37:	50                   	push   %eax
  103e38:	e8 73 fe ff ff       	call   103cb0 <perm2str>
  103e3d:	83 c4 10             	add    $0x10,%esp
  103e40:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  103e42:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103e48:	29 c2                	sub    %eax,%edx
  103e4a:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103e4c:	c1 e0 0c             	shl    $0xc,%eax
  103e4f:	89 c3                	mov    %eax,%ebx
  103e51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103e54:	c1 e0 0c             	shl    $0xc,%eax
  103e57:	89 c1                	mov    %eax,%ecx
  103e59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103e5c:	c1 e0 0c             	shl    $0xc,%eax
  103e5f:	89 c2                	mov    %eax,%edx
  103e61:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  103e64:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103e67:	29 c6                	sub    %eax,%esi
  103e69:	89 f0                	mov    %esi,%eax
  103e6b:	83 ec 08             	sub    $0x8,%esp
  103e6e:	57                   	push   %edi
  103e6f:	53                   	push   %ebx
  103e70:	51                   	push   %ecx
  103e71:	52                   	push   %edx
  103e72:	50                   	push   %eax
  103e73:	68 20 66 10 00       	push   $0x106620
  103e78:	e8 ef c3 ff ff       	call   10026c <cprintf>
  103e7d:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103e80:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  103e85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103e88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e8b:	89 d3                	mov    %edx,%ebx
  103e8d:	c1 e3 0a             	shl    $0xa,%ebx
  103e90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103e93:	89 d1                	mov    %edx,%ecx
  103e95:	c1 e1 0a             	shl    $0xa,%ecx
  103e98:	83 ec 08             	sub    $0x8,%esp
  103e9b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  103e9e:	52                   	push   %edx
  103e9f:	8d 55 d8             	lea    -0x28(%ebp),%edx
  103ea2:	52                   	push   %edx
  103ea3:	56                   	push   %esi
  103ea4:	50                   	push   %eax
  103ea5:	53                   	push   %ebx
  103ea6:	51                   	push   %ecx
  103ea7:	e8 52 fe ff ff       	call   103cfe <get_pgtable_items>
  103eac:	83 c4 20             	add    $0x20,%esp
  103eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103eb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb6:	0f 85 75 ff ff ff    	jne    103e31 <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103ebc:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  103ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ec4:	83 ec 08             	sub    $0x8,%esp
  103ec7:	8d 55 dc             	lea    -0x24(%ebp),%edx
  103eca:	52                   	push   %edx
  103ecb:	8d 55 e0             	lea    -0x20(%ebp),%edx
  103ece:	52                   	push   %edx
  103ecf:	51                   	push   %ecx
  103ed0:	50                   	push   %eax
  103ed1:	68 00 04 00 00       	push   $0x400
  103ed6:	6a 00                	push   $0x0
  103ed8:	e8 21 fe ff ff       	call   103cfe <get_pgtable_items>
  103edd:	83 c4 20             	add    $0x20,%esp
  103ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ee3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ee7:	0f 85 ea fe ff ff    	jne    103dd7 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  103eed:	83 ec 0c             	sub    $0xc,%esp
  103ef0:	68 44 66 10 00       	push   $0x106644
  103ef5:	e8 72 c3 ff ff       	call   10026c <cprintf>
  103efa:	83 c4 10             	add    $0x10,%esp
}
  103efd:	90                   	nop
  103efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103f01:	5b                   	pop    %ebx
  103f02:	5e                   	pop    %esi
  103f03:	5f                   	pop    %edi
  103f04:	5d                   	pop    %ebp
  103f05:	c3                   	ret    

00103f06 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103f06:	55                   	push   %ebp
  103f07:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103f09:	8b 45 08             	mov    0x8(%ebp),%eax
  103f0c:	8b 15 58 89 11 00    	mov    0x118958,%edx
  103f12:	29 d0                	sub    %edx,%eax
  103f14:	c1 f8 02             	sar    $0x2,%eax
  103f17:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103f1d:	5d                   	pop    %ebp
  103f1e:	c3                   	ret    

00103f1f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103f1f:	55                   	push   %ebp
  103f20:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  103f22:	ff 75 08             	pushl  0x8(%ebp)
  103f25:	e8 dc ff ff ff       	call   103f06 <page2ppn>
  103f2a:	83 c4 04             	add    $0x4,%esp
  103f2d:	c1 e0 0c             	shl    $0xc,%eax
}
  103f30:	c9                   	leave  
  103f31:	c3                   	ret    

00103f32 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103f32:	55                   	push   %ebp
  103f33:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103f35:	8b 45 08             	mov    0x8(%ebp),%eax
  103f38:	8b 00                	mov    (%eax),%eax
}
  103f3a:	5d                   	pop    %ebp
  103f3b:	c3                   	ret    

00103f3c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103f3c:	55                   	push   %ebp
  103f3d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f45:	89 10                	mov    %edx,(%eax)
}
  103f47:	90                   	nop
  103f48:	5d                   	pop    %ebp
  103f49:	c3                   	ret    

00103f4a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  103f4a:	55                   	push   %ebp
  103f4b:	89 e5                	mov    %esp,%ebp
  103f4d:	83 ec 10             	sub    $0x10,%esp
  103f50:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103f5d:	89 50 04             	mov    %edx,0x4(%eax)
  103f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f63:	8b 50 04             	mov    0x4(%eax),%edx
  103f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f69:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  103f6b:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  103f72:	00 00 00 
}
  103f75:	90                   	nop
  103f76:	c9                   	leave  
  103f77:	c3                   	ret    

00103f78 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  103f78:	55                   	push   %ebp
  103f79:	89 e5                	mov    %esp,%ebp
  103f7b:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
  103f7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103f82:	75 16                	jne    103f9a <default_init_memmap+0x22>
  103f84:	68 78 66 10 00       	push   $0x106678
  103f89:	68 7e 66 10 00       	push   $0x10667e
  103f8e:	6a 46                	push   $0x46
  103f90:	68 93 66 10 00       	push   $0x106693
  103f95:	e8 38 c4 ff ff       	call   1003d2 <__panic>
    struct Page *p = base;
  103f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  103f9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  103fa0:	e9 cb 00 00 00       	jmp    104070 <default_init_memmap+0xf8>
        assert(PageReserved(p));
  103fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fa8:	83 c0 04             	add    $0x4,%eax
  103fab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  103fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103fbb:	0f a3 10             	bt     %edx,(%eax)
  103fbe:	19 c0                	sbb    %eax,%eax
  103fc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  103fc3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103fc7:	0f 95 c0             	setne  %al
  103fca:	0f b6 c0             	movzbl %al,%eax
  103fcd:	85 c0                	test   %eax,%eax
  103fcf:	75 16                	jne    103fe7 <default_init_memmap+0x6f>
  103fd1:	68 a9 66 10 00       	push   $0x1066a9
  103fd6:	68 7e 66 10 00       	push   $0x10667e
  103fdb:	6a 49                	push   $0x49
  103fdd:	68 93 66 10 00       	push   $0x106693
  103fe2:	e8 eb c3 ff ff       	call   1003d2 <__panic>
        p->flags = 0;
  103fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  103ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff4:	83 c0 04             	add    $0x4,%eax
  103ff7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  103ffe:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104001:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104004:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104007:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  10400a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10400d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  104014:	83 ec 08             	sub    $0x8,%esp
  104017:	6a 00                	push   $0x0
  104019:	ff 75 f4             	pushl  -0xc(%ebp)
  10401c:	e8 1b ff ff ff       	call   103f3c <set_page_ref>
  104021:	83 c4 10             	add    $0x10,%esp
        list_add_before(&free_list, &(p->page_link));
  104024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104027:	83 c0 0c             	add    $0xc,%eax
  10402a:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
  104031:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  104034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104037:	8b 00                	mov    (%eax),%eax
  104039:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10403c:	89 55 d8             	mov    %edx,-0x28(%ebp)
  10403f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104045:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104048:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10404b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10404e:	89 10                	mov    %edx,(%eax)
  104050:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104053:	8b 10                	mov    (%eax),%edx
  104055:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104058:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10405b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10405e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104061:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104064:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10406a:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  10406c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104070:	8b 55 0c             	mov    0xc(%ebp),%edx
  104073:	89 d0                	mov    %edx,%eax
  104075:	c1 e0 02             	shl    $0x2,%eax
  104078:	01 d0                	add    %edx,%eax
  10407a:	c1 e0 02             	shl    $0x2,%eax
  10407d:	89 c2                	mov    %eax,%edx
  10407f:	8b 45 08             	mov    0x8(%ebp),%eax
  104082:	01 d0                	add    %edx,%eax
  104084:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104087:	0f 85 18 ff ff ff    	jne    103fa5 <default_init_memmap+0x2d>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  10408d:	8b 45 08             	mov    0x8(%ebp),%eax
  104090:	8b 55 0c             	mov    0xc(%ebp),%edx
  104093:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  104096:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10409c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10409f:	01 d0                	add    %edx,%eax
  1040a1:	a3 64 89 11 00       	mov    %eax,0x118964
}
  1040a6:	90                   	nop
  1040a7:	c9                   	leave  
  1040a8:	c3                   	ret    

001040a9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1040a9:	55                   	push   %ebp
  1040aa:	89 e5                	mov    %esp,%ebp
  1040ac:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1040af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1040b3:	75 16                	jne    1040cb <default_alloc_pages+0x22>
  1040b5:	68 78 66 10 00       	push   $0x106678
  1040ba:	68 7e 66 10 00       	push   $0x10667e
  1040bf:	6a 56                	push   $0x56
  1040c1:	68 93 66 10 00       	push   $0x106693
  1040c6:	e8 07 c3 ff ff       	call   1003d2 <__panic>
    if (n > nr_free) {
  1040cb:	a1 64 89 11 00       	mov    0x118964,%eax
  1040d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  1040d3:	73 0a                	jae    1040df <default_alloc_pages+0x36>
        return NULL;
  1040d5:	b8 00 00 00 00       	mov    $0x0,%eax
  1040da:	e9 05 01 00 00       	jmp    1041e4 <default_alloc_pages+0x13b>
    }
    list_entry_t *le = &free_list;
  1040df:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1040e6:	e9 d8 00 00 00       	jmp    1041c3 <default_alloc_pages+0x11a>
        struct Page *p = le2page(le, page_link);
  1040eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040ee:	83 e8 0c             	sub    $0xc,%eax
  1040f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1040f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040f7:	8b 40 08             	mov    0x8(%eax),%eax
  1040fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  1040fd:	0f 82 c0 00 00 00    	jb     1041c3 <default_alloc_pages+0x11a>
            for (int i = 0; i < n; ++i) {
  104103:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10410a:	eb 7c                	jmp    104188 <default_alloc_pages+0xdf>
  10410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410f:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104112:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104115:	8b 40 04             	mov    0x4(%eax),%eax
                list_entry_t *len = list_next(le);
  104118:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                struct Page *pp = le2page(le, page_link);
  10411b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10411e:	83 e8 0c             	sub    $0xc,%eax
  104121:	89 45 e0             	mov    %eax,-0x20(%ebp)
                SetPageReserved(pp);
  104124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104127:	83 c0 04             	add    $0x4,%eax
  10412a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  104131:	89 45 c0             	mov    %eax,-0x40(%ebp)
  104134:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104137:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10413a:	0f ab 10             	bts    %edx,(%eax)
                ClearPageProperty(pp);
  10413d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104140:	83 c0 04             	add    $0x4,%eax
  104143:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10414a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10414d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104150:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104153:	0f b3 10             	btr    %edx,(%eax)
  104156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104159:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10415c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10415f:	8b 40 04             	mov    0x4(%eax),%eax
  104162:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104165:	8b 12                	mov    (%edx),%edx
  104167:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10416a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10416d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104170:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104173:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104176:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104179:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10417c:	89 10                	mov    %edx,(%eax)
                list_del(pp);
                le = len;
  10417e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104181:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            for (int i = 0; i < n; ++i) {
  104184:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  104188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10418b:	3b 45 08             	cmp    0x8(%ebp),%eax
  10418e:	0f 82 78 ff ff ff    	jb     10410c <default_alloc_pages+0x63>
                SetPageReserved(pp);
                ClearPageProperty(pp);
                list_del(pp);
                le = len;
            }
            if(p->property > n) {
  104194:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104197:	8b 40 08             	mov    0x8(%eax),%eax
  10419a:	3b 45 08             	cmp    0x8(%ebp),%eax
  10419d:	76 12                	jbe    1041b1 <default_alloc_pages+0x108>
                (le2page(le, page_link))->property = p->property - n;
  10419f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041a2:	8d 50 f4             	lea    -0xc(%eax),%edx
  1041a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041a8:	8b 40 08             	mov    0x8(%eax),%eax
  1041ab:	2b 45 08             	sub    0x8(%ebp),%eax
  1041ae:	89 42 08             	mov    %eax,0x8(%edx)
            }
            nr_free -= n;
  1041b1:	a1 64 89 11 00       	mov    0x118964,%eax
  1041b6:	2b 45 08             	sub    0x8(%ebp),%eax
  1041b9:	a3 64 89 11 00       	mov    %eax,0x118964
            return p;
  1041be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041c1:	eb 21                	jmp    1041e4 <default_alloc_pages+0x13b>
  1041c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1041c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041cc:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1041cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1041d2:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  1041d9:	0f 85 0c ff ff ff    	jne    1040eb <default_alloc_pages+0x42>
            }
            nr_free -= n;
            return p;
        }
    }
    return NULL;
  1041df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1041e4:	c9                   	leave  
  1041e5:	c3                   	ret    

001041e6 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  1041e6:	55                   	push   %ebp
  1041e7:	89 e5                	mov    %esp,%ebp
  1041e9:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1041ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1041f0:	75 16                	jne    104208 <default_free_pages+0x22>
  1041f2:	68 78 66 10 00       	push   $0x106678
  1041f7:	68 7e 66 10 00       	push   $0x10667e
  1041fc:	6a 72                	push   $0x72
  1041fe:	68 93 66 10 00       	push   $0x106693
  104203:	e8 ca c1 ff ff       	call   1003d2 <__panic>
    assert(PageReserved(base));
  104208:	8b 45 08             	mov    0x8(%ebp),%eax
  10420b:	83 c0 04             	add    $0x4,%eax
  10420e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  104215:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104218:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10421b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10421e:	0f a3 10             	bt     %edx,(%eax)
  104221:	19 c0                	sbb    %eax,%eax
  104223:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
  104226:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10422a:	0f 95 c0             	setne  %al
  10422d:	0f b6 c0             	movzbl %al,%eax
  104230:	85 c0                	test   %eax,%eax
  104232:	75 16                	jne    10424a <default_free_pages+0x64>
  104234:	68 b9 66 10 00       	push   $0x1066b9
  104239:	68 7e 66 10 00       	push   $0x10667e
  10423e:	6a 73                	push   $0x73
  104240:	68 93 66 10 00       	push   $0x106693
  104245:	e8 88 c1 ff ff       	call   1003d2 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
  10424a:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
    while( (le = list_next(le))!= &free_list) {
  104251:	eb 11                	jmp    104264 <default_free_pages+0x7e>
        p = le2page(le, page_link);
  104253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104256:	83 e8 0c             	sub    $0xc,%eax
  104259:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(p > base) {break;}
  10425c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10425f:	3b 45 08             	cmp    0x8(%ebp),%eax
  104262:	77 1a                	ja     10427e <default_free_pages+0x98>
  104264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104267:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10426a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10426d:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    assert(PageReserved(base));
    struct Page *p;
    list_entry_t *le = &free_list;
    while( (le = list_next(le))!= &free_list) {
  104270:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104273:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  10427a:	75 d7                	jne    104253 <default_free_pages+0x6d>
  10427c:	eb 01                	jmp    10427f <default_free_pages+0x99>
        p = le2page(le, page_link);
        if(p > base) {break;}
  10427e:	90                   	nop
    }
    for (p=base; p < base + n; ++p) {
  10427f:	8b 45 08             	mov    0x8(%ebp),%eax
  104282:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104285:	e9 89 00 00 00       	jmp    104313 <default_free_pages+0x12d>
        p->flags = 0;
  10428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10428d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = 0;
  104294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104297:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        SetPageProperty(p);
  10429e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042a1:	83 c0 04             	add    $0x4,%eax
  1042a4:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1042ab:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1042ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1042b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042b4:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p,0);
  1042b7:	83 ec 08             	sub    $0x8,%esp
  1042ba:	6a 00                	push   $0x0
  1042bc:	ff 75 f4             	pushl  -0xc(%ebp)
  1042bf:	e8 78 fc ff ff       	call   103f3c <set_page_ref>
  1042c4:	83 c4 10             	add    $0x10,%esp
        list_add_before(&free_list, &(p->page_link));
  1042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ca:	83 c0 0c             	add    $0xc,%eax
  1042cd:	c7 45 e8 5c 89 11 00 	movl   $0x11895c,-0x18(%ebp)
  1042d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1042d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042da:	8b 00                	mov    (%eax),%eax
  1042dc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1042df:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1042e2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1042e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1042eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1042f1:	89 10                	mov    %edx,(%eax)
  1042f3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042f6:	8b 10                	mov    (%eax),%edx
  1042f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1042fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1042fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104301:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104304:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104307:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10430a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10430d:	89 10                	mov    %edx,(%eax)
    list_entry_t *le = &free_list;
    while( (le = list_next(le))!= &free_list) {
        p = le2page(le, page_link);
        if(p > base) {break;}
    }
    for (p=base; p < base + n; ++p) {
  10430f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104313:	8b 55 0c             	mov    0xc(%ebp),%edx
  104316:	89 d0                	mov    %edx,%eax
  104318:	c1 e0 02             	shl    $0x2,%eax
  10431b:	01 d0                	add    %edx,%eax
  10431d:	c1 e0 02             	shl    $0x2,%eax
  104320:	89 c2                	mov    %eax,%edx
  104322:	8b 45 08             	mov    0x8(%ebp),%eax
  104325:	01 d0                	add    %edx,%eax
  104327:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10432a:	0f 87 5a ff ff ff    	ja     10428a <default_free_pages+0xa4>
        p->property = 0;
        SetPageProperty(p);
        set_page_ref(p,0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  104330:	8b 45 08             	mov    0x8(%ebp),%eax
  104333:	8b 55 0c             	mov    0xc(%ebp),%edx
  104336:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104339:	8b 45 08             	mov    0x8(%ebp),%eax
  10433c:	83 c0 04             	add    $0x4,%eax
  10433f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  104346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  104349:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10434c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10434f:	0f ab 10             	bts    %edx,(%eax)

    p = le2page(le, page_link);
  104352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104355:	83 e8 0c             	sub    $0xc,%eax
  104358:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(base+n == p) {
  10435b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10435e:	89 d0                	mov    %edx,%eax
  104360:	c1 e0 02             	shl    $0x2,%eax
  104363:	01 d0                	add    %edx,%eax
  104365:	c1 e0 02             	shl    $0x2,%eax
  104368:	89 c2                	mov    %eax,%edx
  10436a:	8b 45 08             	mov    0x8(%ebp),%eax
  10436d:	01 d0                	add    %edx,%eax
  10436f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104372:	75 1e                	jne    104392 <default_free_pages+0x1ac>
        base->property += p->property;
  104374:	8b 45 08             	mov    0x8(%ebp),%eax
  104377:	8b 50 08             	mov    0x8(%eax),%edx
  10437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437d:	8b 40 08             	mov    0x8(%eax),%eax
  104380:	01 c2                	add    %eax,%edx
  104382:	8b 45 08             	mov    0x8(%ebp),%eax
  104385:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
  104388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10438b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104395:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  104398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10439b:	8b 00                	mov    (%eax),%eax
    }

    le = list_prev(le);
  10439d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le, page_link);
  1043a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043a3:	83 e8 0c             	sub    $0xc,%eax
  1043a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p==base-1){
  1043a9:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  1043b0:	74 57                	je     104409 <default_free_pages+0x223>
  1043b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b5:	83 e8 14             	sub    $0x14,%eax
  1043b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1043bb:	75 4c                	jne    104409 <default_free_pages+0x223>
        while(le != &free_list) {
  1043bd:	eb 41                	jmp    104400 <default_free_pages+0x21a>
            //p = le2page(le, page_link);
            if(p->property) {
  1043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043c2:	8b 40 08             	mov    0x8(%eax),%eax
  1043c5:	85 c0                	test   %eax,%eax
  1043c7:	74 20                	je     1043e9 <default_free_pages+0x203>
                p->property += base->property;
  1043c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043cc:	8b 50 08             	mov    0x8(%eax),%edx
  1043cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d2:	8b 40 08             	mov    0x8(%eax),%eax
  1043d5:	01 c2                	add    %eax,%edx
  1043d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043da:	89 50 08             	mov    %edx,0x8(%eax)
                base->property = 0;
  1043dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1043e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                break;
  1043e7:	eb 20                	jmp    104409 <default_free_pages+0x223>
  1043e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1043ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1043f2:	8b 00                	mov    (%eax),%eax
            }
            le = list_prev(le);
  1043f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = le2page(le, page_link);
  1043f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043fa:	83 e8 0c             	sub    $0xc,%eax
  1043fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    le = list_prev(le);
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
        while(le != &free_list) {
  104400:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  104407:	75 b6                	jne    1043bf <default_free_pages+0x1d9>
            le = list_prev(le);
            p = le2page(le, page_link);
        }
    }

    nr_free += n;
  104409:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10440f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104412:	01 d0                	add    %edx,%eax
  104414:	a3 64 89 11 00       	mov    %eax,0x118964
    //list_add(&free_list, &(base->page_link));
}
  104419:	90                   	nop
  10441a:	c9                   	leave  
  10441b:	c3                   	ret    

0010441c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10441c:	55                   	push   %ebp
  10441d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10441f:	a1 64 89 11 00       	mov    0x118964,%eax
}
  104424:	5d                   	pop    %ebp
  104425:	c3                   	ret    

00104426 <basic_check>:

static void
basic_check(void) {
  104426:	55                   	push   %ebp
  104427:	89 e5                	mov    %esp,%ebp
  104429:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10442c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10443c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10443f:	83 ec 0c             	sub    $0xc,%esp
  104442:	6a 01                	push   $0x1
  104444:	e8 88 e7 ff ff       	call   102bd1 <alloc_pages>
  104449:	83 c4 10             	add    $0x10,%esp
  10444c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10444f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104453:	75 19                	jne    10446e <basic_check+0x48>
  104455:	68 cc 66 10 00       	push   $0x1066cc
  10445a:	68 7e 66 10 00       	push   $0x10667e
  10445f:	68 a6 00 00 00       	push   $0xa6
  104464:	68 93 66 10 00       	push   $0x106693
  104469:	e8 64 bf ff ff       	call   1003d2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10446e:	83 ec 0c             	sub    $0xc,%esp
  104471:	6a 01                	push   $0x1
  104473:	e8 59 e7 ff ff       	call   102bd1 <alloc_pages>
  104478:	83 c4 10             	add    $0x10,%esp
  10447b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10447e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104482:	75 19                	jne    10449d <basic_check+0x77>
  104484:	68 e8 66 10 00       	push   $0x1066e8
  104489:	68 7e 66 10 00       	push   $0x10667e
  10448e:	68 a7 00 00 00       	push   $0xa7
  104493:	68 93 66 10 00       	push   $0x106693
  104498:	e8 35 bf ff ff       	call   1003d2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10449d:	83 ec 0c             	sub    $0xc,%esp
  1044a0:	6a 01                	push   $0x1
  1044a2:	e8 2a e7 ff ff       	call   102bd1 <alloc_pages>
  1044a7:	83 c4 10             	add    $0x10,%esp
  1044aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1044ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b1:	75 19                	jne    1044cc <basic_check+0xa6>
  1044b3:	68 04 67 10 00       	push   $0x106704
  1044b8:	68 7e 66 10 00       	push   $0x10667e
  1044bd:	68 a8 00 00 00       	push   $0xa8
  1044c2:	68 93 66 10 00       	push   $0x106693
  1044c7:	e8 06 bf ff ff       	call   1003d2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1044cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1044d2:	74 10                	je     1044e4 <basic_check+0xbe>
  1044d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1044da:	74 08                	je     1044e4 <basic_check+0xbe>
  1044dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1044e2:	75 19                	jne    1044fd <basic_check+0xd7>
  1044e4:	68 20 67 10 00       	push   $0x106720
  1044e9:	68 7e 66 10 00       	push   $0x10667e
  1044ee:	68 aa 00 00 00       	push   $0xaa
  1044f3:	68 93 66 10 00       	push   $0x106693
  1044f8:	e8 d5 be ff ff       	call   1003d2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1044fd:	83 ec 0c             	sub    $0xc,%esp
  104500:	ff 75 ec             	pushl  -0x14(%ebp)
  104503:	e8 2a fa ff ff       	call   103f32 <page_ref>
  104508:	83 c4 10             	add    $0x10,%esp
  10450b:	85 c0                	test   %eax,%eax
  10450d:	75 24                	jne    104533 <basic_check+0x10d>
  10450f:	83 ec 0c             	sub    $0xc,%esp
  104512:	ff 75 f0             	pushl  -0x10(%ebp)
  104515:	e8 18 fa ff ff       	call   103f32 <page_ref>
  10451a:	83 c4 10             	add    $0x10,%esp
  10451d:	85 c0                	test   %eax,%eax
  10451f:	75 12                	jne    104533 <basic_check+0x10d>
  104521:	83 ec 0c             	sub    $0xc,%esp
  104524:	ff 75 f4             	pushl  -0xc(%ebp)
  104527:	e8 06 fa ff ff       	call   103f32 <page_ref>
  10452c:	83 c4 10             	add    $0x10,%esp
  10452f:	85 c0                	test   %eax,%eax
  104531:	74 19                	je     10454c <basic_check+0x126>
  104533:	68 44 67 10 00       	push   $0x106744
  104538:	68 7e 66 10 00       	push   $0x10667e
  10453d:	68 ab 00 00 00       	push   $0xab
  104542:	68 93 66 10 00       	push   $0x106693
  104547:	e8 86 be ff ff       	call   1003d2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10454c:	83 ec 0c             	sub    $0xc,%esp
  10454f:	ff 75 ec             	pushl  -0x14(%ebp)
  104552:	e8 c8 f9 ff ff       	call   103f1f <page2pa>
  104557:	83 c4 10             	add    $0x10,%esp
  10455a:	89 c2                	mov    %eax,%edx
  10455c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104561:	c1 e0 0c             	shl    $0xc,%eax
  104564:	39 c2                	cmp    %eax,%edx
  104566:	72 19                	jb     104581 <basic_check+0x15b>
  104568:	68 80 67 10 00       	push   $0x106780
  10456d:	68 7e 66 10 00       	push   $0x10667e
  104572:	68 ad 00 00 00       	push   $0xad
  104577:	68 93 66 10 00       	push   $0x106693
  10457c:	e8 51 be ff ff       	call   1003d2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104581:	83 ec 0c             	sub    $0xc,%esp
  104584:	ff 75 f0             	pushl  -0x10(%ebp)
  104587:	e8 93 f9 ff ff       	call   103f1f <page2pa>
  10458c:	83 c4 10             	add    $0x10,%esp
  10458f:	89 c2                	mov    %eax,%edx
  104591:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104596:	c1 e0 0c             	shl    $0xc,%eax
  104599:	39 c2                	cmp    %eax,%edx
  10459b:	72 19                	jb     1045b6 <basic_check+0x190>
  10459d:	68 9d 67 10 00       	push   $0x10679d
  1045a2:	68 7e 66 10 00       	push   $0x10667e
  1045a7:	68 ae 00 00 00       	push   $0xae
  1045ac:	68 93 66 10 00       	push   $0x106693
  1045b1:	e8 1c be ff ff       	call   1003d2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1045b6:	83 ec 0c             	sub    $0xc,%esp
  1045b9:	ff 75 f4             	pushl  -0xc(%ebp)
  1045bc:	e8 5e f9 ff ff       	call   103f1f <page2pa>
  1045c1:	83 c4 10             	add    $0x10,%esp
  1045c4:	89 c2                	mov    %eax,%edx
  1045c6:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1045cb:	c1 e0 0c             	shl    $0xc,%eax
  1045ce:	39 c2                	cmp    %eax,%edx
  1045d0:	72 19                	jb     1045eb <basic_check+0x1c5>
  1045d2:	68 ba 67 10 00       	push   $0x1067ba
  1045d7:	68 7e 66 10 00       	push   $0x10667e
  1045dc:	68 af 00 00 00       	push   $0xaf
  1045e1:	68 93 66 10 00       	push   $0x106693
  1045e6:	e8 e7 bd ff ff       	call   1003d2 <__panic>

    list_entry_t free_list_store = free_list;
  1045eb:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1045f0:	8b 15 60 89 11 00    	mov    0x118960,%edx
  1045f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1045f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1045fc:	c7 45 e4 5c 89 11 00 	movl   $0x11895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104606:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104609:	89 50 04             	mov    %edx,0x4(%eax)
  10460c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10460f:	8b 50 04             	mov    0x4(%eax),%edx
  104612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104615:	89 10                	mov    %edx,(%eax)
  104617:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10461e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104621:	8b 40 04             	mov    0x4(%eax),%eax
  104624:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104627:	0f 94 c0             	sete   %al
  10462a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10462d:	85 c0                	test   %eax,%eax
  10462f:	75 19                	jne    10464a <basic_check+0x224>
  104631:	68 d7 67 10 00       	push   $0x1067d7
  104636:	68 7e 66 10 00       	push   $0x10667e
  10463b:	68 b3 00 00 00       	push   $0xb3
  104640:	68 93 66 10 00       	push   $0x106693
  104645:	e8 88 bd ff ff       	call   1003d2 <__panic>

    unsigned int nr_free_store = nr_free;
  10464a:	a1 64 89 11 00       	mov    0x118964,%eax
  10464f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104652:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104659:	00 00 00 

    assert(alloc_page() == NULL);
  10465c:	83 ec 0c             	sub    $0xc,%esp
  10465f:	6a 01                	push   $0x1
  104661:	e8 6b e5 ff ff       	call   102bd1 <alloc_pages>
  104666:	83 c4 10             	add    $0x10,%esp
  104669:	85 c0                	test   %eax,%eax
  10466b:	74 19                	je     104686 <basic_check+0x260>
  10466d:	68 ee 67 10 00       	push   $0x1067ee
  104672:	68 7e 66 10 00       	push   $0x10667e
  104677:	68 b8 00 00 00       	push   $0xb8
  10467c:	68 93 66 10 00       	push   $0x106693
  104681:	e8 4c bd ff ff       	call   1003d2 <__panic>

    free_page(p0);
  104686:	83 ec 08             	sub    $0x8,%esp
  104689:	6a 01                	push   $0x1
  10468b:	ff 75 ec             	pushl  -0x14(%ebp)
  10468e:	e8 7c e5 ff ff       	call   102c0f <free_pages>
  104693:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104696:	83 ec 08             	sub    $0x8,%esp
  104699:	6a 01                	push   $0x1
  10469b:	ff 75 f0             	pushl  -0x10(%ebp)
  10469e:	e8 6c e5 ff ff       	call   102c0f <free_pages>
  1046a3:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  1046a6:	83 ec 08             	sub    $0x8,%esp
  1046a9:	6a 01                	push   $0x1
  1046ab:	ff 75 f4             	pushl  -0xc(%ebp)
  1046ae:	e8 5c e5 ff ff       	call   102c0f <free_pages>
  1046b3:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  1046b6:	a1 64 89 11 00       	mov    0x118964,%eax
  1046bb:	83 f8 03             	cmp    $0x3,%eax
  1046be:	74 19                	je     1046d9 <basic_check+0x2b3>
  1046c0:	68 03 68 10 00       	push   $0x106803
  1046c5:	68 7e 66 10 00       	push   $0x10667e
  1046ca:	68 bd 00 00 00       	push   $0xbd
  1046cf:	68 93 66 10 00       	push   $0x106693
  1046d4:	e8 f9 bc ff ff       	call   1003d2 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1046d9:	83 ec 0c             	sub    $0xc,%esp
  1046dc:	6a 01                	push   $0x1
  1046de:	e8 ee e4 ff ff       	call   102bd1 <alloc_pages>
  1046e3:	83 c4 10             	add    $0x10,%esp
  1046e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1046e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1046ed:	75 19                	jne    104708 <basic_check+0x2e2>
  1046ef:	68 cc 66 10 00       	push   $0x1066cc
  1046f4:	68 7e 66 10 00       	push   $0x10667e
  1046f9:	68 bf 00 00 00       	push   $0xbf
  1046fe:	68 93 66 10 00       	push   $0x106693
  104703:	e8 ca bc ff ff       	call   1003d2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104708:	83 ec 0c             	sub    $0xc,%esp
  10470b:	6a 01                	push   $0x1
  10470d:	e8 bf e4 ff ff       	call   102bd1 <alloc_pages>
  104712:	83 c4 10             	add    $0x10,%esp
  104715:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104718:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10471c:	75 19                	jne    104737 <basic_check+0x311>
  10471e:	68 e8 66 10 00       	push   $0x1066e8
  104723:	68 7e 66 10 00       	push   $0x10667e
  104728:	68 c0 00 00 00       	push   $0xc0
  10472d:	68 93 66 10 00       	push   $0x106693
  104732:	e8 9b bc ff ff       	call   1003d2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104737:	83 ec 0c             	sub    $0xc,%esp
  10473a:	6a 01                	push   $0x1
  10473c:	e8 90 e4 ff ff       	call   102bd1 <alloc_pages>
  104741:	83 c4 10             	add    $0x10,%esp
  104744:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10474b:	75 19                	jne    104766 <basic_check+0x340>
  10474d:	68 04 67 10 00       	push   $0x106704
  104752:	68 7e 66 10 00       	push   $0x10667e
  104757:	68 c1 00 00 00       	push   $0xc1
  10475c:	68 93 66 10 00       	push   $0x106693
  104761:	e8 6c bc ff ff       	call   1003d2 <__panic>

    assert(alloc_page() == NULL);
  104766:	83 ec 0c             	sub    $0xc,%esp
  104769:	6a 01                	push   $0x1
  10476b:	e8 61 e4 ff ff       	call   102bd1 <alloc_pages>
  104770:	83 c4 10             	add    $0x10,%esp
  104773:	85 c0                	test   %eax,%eax
  104775:	74 19                	je     104790 <basic_check+0x36a>
  104777:	68 ee 67 10 00       	push   $0x1067ee
  10477c:	68 7e 66 10 00       	push   $0x10667e
  104781:	68 c3 00 00 00       	push   $0xc3
  104786:	68 93 66 10 00       	push   $0x106693
  10478b:	e8 42 bc ff ff       	call   1003d2 <__panic>

    free_page(p0);
  104790:	83 ec 08             	sub    $0x8,%esp
  104793:	6a 01                	push   $0x1
  104795:	ff 75 ec             	pushl  -0x14(%ebp)
  104798:	e8 72 e4 ff ff       	call   102c0f <free_pages>
  10479d:	83 c4 10             	add    $0x10,%esp
  1047a0:	c7 45 e8 5c 89 11 00 	movl   $0x11895c,-0x18(%ebp)
  1047a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1047aa:	8b 40 04             	mov    0x4(%eax),%eax
  1047ad:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1047b0:	0f 94 c0             	sete   %al
  1047b3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1047b6:	85 c0                	test   %eax,%eax
  1047b8:	74 19                	je     1047d3 <basic_check+0x3ad>
  1047ba:	68 10 68 10 00       	push   $0x106810
  1047bf:	68 7e 66 10 00       	push   $0x10667e
  1047c4:	68 c6 00 00 00       	push   $0xc6
  1047c9:	68 93 66 10 00       	push   $0x106693
  1047ce:	e8 ff bb ff ff       	call   1003d2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1047d3:	83 ec 0c             	sub    $0xc,%esp
  1047d6:	6a 01                	push   $0x1
  1047d8:	e8 f4 e3 ff ff       	call   102bd1 <alloc_pages>
  1047dd:	83 c4 10             	add    $0x10,%esp
  1047e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1047e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1047e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1047e9:	74 19                	je     104804 <basic_check+0x3de>
  1047eb:	68 28 68 10 00       	push   $0x106828
  1047f0:	68 7e 66 10 00       	push   $0x10667e
  1047f5:	68 c9 00 00 00       	push   $0xc9
  1047fa:	68 93 66 10 00       	push   $0x106693
  1047ff:	e8 ce bb ff ff       	call   1003d2 <__panic>
    assert(alloc_page() == NULL);
  104804:	83 ec 0c             	sub    $0xc,%esp
  104807:	6a 01                	push   $0x1
  104809:	e8 c3 e3 ff ff       	call   102bd1 <alloc_pages>
  10480e:	83 c4 10             	add    $0x10,%esp
  104811:	85 c0                	test   %eax,%eax
  104813:	74 19                	je     10482e <basic_check+0x408>
  104815:	68 ee 67 10 00       	push   $0x1067ee
  10481a:	68 7e 66 10 00       	push   $0x10667e
  10481f:	68 ca 00 00 00       	push   $0xca
  104824:	68 93 66 10 00       	push   $0x106693
  104829:	e8 a4 bb ff ff       	call   1003d2 <__panic>

    assert(nr_free == 0);
  10482e:	a1 64 89 11 00       	mov    0x118964,%eax
  104833:	85 c0                	test   %eax,%eax
  104835:	74 19                	je     104850 <basic_check+0x42a>
  104837:	68 41 68 10 00       	push   $0x106841
  10483c:	68 7e 66 10 00       	push   $0x10667e
  104841:	68 cc 00 00 00       	push   $0xcc
  104846:	68 93 66 10 00       	push   $0x106693
  10484b:	e8 82 bb ff ff       	call   1003d2 <__panic>
    free_list = free_list_store;
  104850:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104853:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104856:	a3 5c 89 11 00       	mov    %eax,0x11895c
  10485b:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  104861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104864:	a3 64 89 11 00       	mov    %eax,0x118964

    free_page(p);
  104869:	83 ec 08             	sub    $0x8,%esp
  10486c:	6a 01                	push   $0x1
  10486e:	ff 75 dc             	pushl  -0x24(%ebp)
  104871:	e8 99 e3 ff ff       	call   102c0f <free_pages>
  104876:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104879:	83 ec 08             	sub    $0x8,%esp
  10487c:	6a 01                	push   $0x1
  10487e:	ff 75 f0             	pushl  -0x10(%ebp)
  104881:	e8 89 e3 ff ff       	call   102c0f <free_pages>
  104886:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104889:	83 ec 08             	sub    $0x8,%esp
  10488c:	6a 01                	push   $0x1
  10488e:	ff 75 f4             	pushl  -0xc(%ebp)
  104891:	e8 79 e3 ff ff       	call   102c0f <free_pages>
  104896:	83 c4 10             	add    $0x10,%esp
}
  104899:	90                   	nop
  10489a:	c9                   	leave  
  10489b:	c3                   	ret    

0010489c <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10489c:	55                   	push   %ebp
  10489d:	89 e5                	mov    %esp,%ebp
  10489f:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  1048a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1048ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1048b3:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1048ba:	eb 60                	jmp    10491c <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  1048bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048bf:	83 e8 0c             	sub    $0xc,%eax
  1048c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  1048c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048c8:	83 c0 04             	add    $0x4,%eax
  1048cb:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  1048d2:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048d5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1048d8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1048db:	0f a3 10             	bt     %edx,(%eax)
  1048de:	19 c0                	sbb    %eax,%eax
  1048e0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  1048e3:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  1048e7:	0f 95 c0             	setne  %al
  1048ea:	0f b6 c0             	movzbl %al,%eax
  1048ed:	85 c0                	test   %eax,%eax
  1048ef:	75 19                	jne    10490a <default_check+0x6e>
  1048f1:	68 4e 68 10 00       	push   $0x10684e
  1048f6:	68 7e 66 10 00       	push   $0x10667e
  1048fb:	68 dd 00 00 00       	push   $0xdd
  104900:	68 93 66 10 00       	push   $0x106693
  104905:	e8 c8 ba ff ff       	call   1003d2 <__panic>
        count ++, total += p->property;
  10490a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10490e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104911:	8b 50 08             	mov    0x8(%eax),%edx
  104914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104917:	01 d0                	add    %edx,%eax
  104919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10491c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10491f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104925:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104928:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10492b:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104932:	75 88                	jne    1048bc <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104934:	e8 0b e3 ff ff       	call   102c44 <nr_free_pages>
  104939:	89 c2                	mov    %eax,%edx
  10493b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10493e:	39 c2                	cmp    %eax,%edx
  104940:	74 19                	je     10495b <default_check+0xbf>
  104942:	68 5e 68 10 00       	push   $0x10685e
  104947:	68 7e 66 10 00       	push   $0x10667e
  10494c:	68 e0 00 00 00       	push   $0xe0
  104951:	68 93 66 10 00       	push   $0x106693
  104956:	e8 77 ba ff ff       	call   1003d2 <__panic>

    basic_check();
  10495b:	e8 c6 fa ff ff       	call   104426 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104960:	83 ec 0c             	sub    $0xc,%esp
  104963:	6a 05                	push   $0x5
  104965:	e8 67 e2 ff ff       	call   102bd1 <alloc_pages>
  10496a:	83 c4 10             	add    $0x10,%esp
  10496d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104970:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104974:	75 19                	jne    10498f <default_check+0xf3>
  104976:	68 77 68 10 00       	push   $0x106877
  10497b:	68 7e 66 10 00       	push   $0x10667e
  104980:	68 e5 00 00 00       	push   $0xe5
  104985:	68 93 66 10 00       	push   $0x106693
  10498a:	e8 43 ba ff ff       	call   1003d2 <__panic>
    assert(!PageProperty(p0));
  10498f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104992:	83 c0 04             	add    $0x4,%eax
  104995:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  10499c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10499f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1049a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1049a5:	0f a3 10             	bt     %edx,(%eax)
  1049a8:	19 c0                	sbb    %eax,%eax
  1049aa:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  1049ad:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  1049b1:	0f 95 c0             	setne  %al
  1049b4:	0f b6 c0             	movzbl %al,%eax
  1049b7:	85 c0                	test   %eax,%eax
  1049b9:	74 19                	je     1049d4 <default_check+0x138>
  1049bb:	68 82 68 10 00       	push   $0x106882
  1049c0:	68 7e 66 10 00       	push   $0x10667e
  1049c5:	68 e6 00 00 00       	push   $0xe6
  1049ca:	68 93 66 10 00       	push   $0x106693
  1049cf:	e8 fe b9 ff ff       	call   1003d2 <__panic>

    list_entry_t free_list_store = free_list;
  1049d4:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1049d9:	8b 15 60 89 11 00    	mov    0x118960,%edx
  1049df:	89 45 80             	mov    %eax,-0x80(%ebp)
  1049e2:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1049e5:	c7 45 d0 5c 89 11 00 	movl   $0x11895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1049ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049ef:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1049f2:	89 50 04             	mov    %edx,0x4(%eax)
  1049f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049f8:	8b 50 04             	mov    0x4(%eax),%edx
  1049fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049fe:	89 10                	mov    %edx,(%eax)
  104a00:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104a07:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104a0a:	8b 40 04             	mov    0x4(%eax),%eax
  104a0d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104a10:	0f 94 c0             	sete   %al
  104a13:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104a16:	85 c0                	test   %eax,%eax
  104a18:	75 19                	jne    104a33 <default_check+0x197>
  104a1a:	68 d7 67 10 00       	push   $0x1067d7
  104a1f:	68 7e 66 10 00       	push   $0x10667e
  104a24:	68 ea 00 00 00       	push   $0xea
  104a29:	68 93 66 10 00       	push   $0x106693
  104a2e:	e8 9f b9 ff ff       	call   1003d2 <__panic>
    assert(alloc_page() == NULL);
  104a33:	83 ec 0c             	sub    $0xc,%esp
  104a36:	6a 01                	push   $0x1
  104a38:	e8 94 e1 ff ff       	call   102bd1 <alloc_pages>
  104a3d:	83 c4 10             	add    $0x10,%esp
  104a40:	85 c0                	test   %eax,%eax
  104a42:	74 19                	je     104a5d <default_check+0x1c1>
  104a44:	68 ee 67 10 00       	push   $0x1067ee
  104a49:	68 7e 66 10 00       	push   $0x10667e
  104a4e:	68 eb 00 00 00       	push   $0xeb
  104a53:	68 93 66 10 00       	push   $0x106693
  104a58:	e8 75 b9 ff ff       	call   1003d2 <__panic>

    unsigned int nr_free_store = nr_free;
  104a5d:	a1 64 89 11 00       	mov    0x118964,%eax
  104a62:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104a65:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104a6c:	00 00 00 

    free_pages(p0 + 2, 3);
  104a6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a72:	83 c0 28             	add    $0x28,%eax
  104a75:	83 ec 08             	sub    $0x8,%esp
  104a78:	6a 03                	push   $0x3
  104a7a:	50                   	push   %eax
  104a7b:	e8 8f e1 ff ff       	call   102c0f <free_pages>
  104a80:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104a83:	83 ec 0c             	sub    $0xc,%esp
  104a86:	6a 04                	push   $0x4
  104a88:	e8 44 e1 ff ff       	call   102bd1 <alloc_pages>
  104a8d:	83 c4 10             	add    $0x10,%esp
  104a90:	85 c0                	test   %eax,%eax
  104a92:	74 19                	je     104aad <default_check+0x211>
  104a94:	68 94 68 10 00       	push   $0x106894
  104a99:	68 7e 66 10 00       	push   $0x10667e
  104a9e:	68 f1 00 00 00       	push   $0xf1
  104aa3:	68 93 66 10 00       	push   $0x106693
  104aa8:	e8 25 b9 ff ff       	call   1003d2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ab0:	83 c0 28             	add    $0x28,%eax
  104ab3:	83 c0 04             	add    $0x4,%eax
  104ab6:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104abd:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ac0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104ac3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ac6:	0f a3 10             	bt     %edx,(%eax)
  104ac9:	19 c0                	sbb    %eax,%eax
  104acb:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104ace:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104ad2:	0f 95 c0             	setne  %al
  104ad5:	0f b6 c0             	movzbl %al,%eax
  104ad8:	85 c0                	test   %eax,%eax
  104ada:	74 0e                	je     104aea <default_check+0x24e>
  104adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104adf:	83 c0 28             	add    $0x28,%eax
  104ae2:	8b 40 08             	mov    0x8(%eax),%eax
  104ae5:	83 f8 03             	cmp    $0x3,%eax
  104ae8:	74 19                	je     104b03 <default_check+0x267>
  104aea:	68 ac 68 10 00       	push   $0x1068ac
  104aef:	68 7e 66 10 00       	push   $0x10667e
  104af4:	68 f2 00 00 00       	push   $0xf2
  104af9:	68 93 66 10 00       	push   $0x106693
  104afe:	e8 cf b8 ff ff       	call   1003d2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104b03:	83 ec 0c             	sub    $0xc,%esp
  104b06:	6a 03                	push   $0x3
  104b08:	e8 c4 e0 ff ff       	call   102bd1 <alloc_pages>
  104b0d:	83 c4 10             	add    $0x10,%esp
  104b10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104b13:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104b17:	75 19                	jne    104b32 <default_check+0x296>
  104b19:	68 d8 68 10 00       	push   $0x1068d8
  104b1e:	68 7e 66 10 00       	push   $0x10667e
  104b23:	68 f3 00 00 00       	push   $0xf3
  104b28:	68 93 66 10 00       	push   $0x106693
  104b2d:	e8 a0 b8 ff ff       	call   1003d2 <__panic>
    assert(alloc_page() == NULL);
  104b32:	83 ec 0c             	sub    $0xc,%esp
  104b35:	6a 01                	push   $0x1
  104b37:	e8 95 e0 ff ff       	call   102bd1 <alloc_pages>
  104b3c:	83 c4 10             	add    $0x10,%esp
  104b3f:	85 c0                	test   %eax,%eax
  104b41:	74 19                	je     104b5c <default_check+0x2c0>
  104b43:	68 ee 67 10 00       	push   $0x1067ee
  104b48:	68 7e 66 10 00       	push   $0x10667e
  104b4d:	68 f4 00 00 00       	push   $0xf4
  104b52:	68 93 66 10 00       	push   $0x106693
  104b57:	e8 76 b8 ff ff       	call   1003d2 <__panic>
    assert(p0 + 2 == p1);
  104b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b5f:	83 c0 28             	add    $0x28,%eax
  104b62:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104b65:	74 19                	je     104b80 <default_check+0x2e4>
  104b67:	68 f6 68 10 00       	push   $0x1068f6
  104b6c:	68 7e 66 10 00       	push   $0x10667e
  104b71:	68 f5 00 00 00       	push   $0xf5
  104b76:	68 93 66 10 00       	push   $0x106693
  104b7b:	e8 52 b8 ff ff       	call   1003d2 <__panic>

    p2 = p0 + 1;
  104b80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b83:	83 c0 14             	add    $0x14,%eax
  104b86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104b89:	83 ec 08             	sub    $0x8,%esp
  104b8c:	6a 01                	push   $0x1
  104b8e:	ff 75 dc             	pushl  -0x24(%ebp)
  104b91:	e8 79 e0 ff ff       	call   102c0f <free_pages>
  104b96:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  104b99:	83 ec 08             	sub    $0x8,%esp
  104b9c:	6a 03                	push   $0x3
  104b9e:	ff 75 c4             	pushl  -0x3c(%ebp)
  104ba1:	e8 69 e0 ff ff       	call   102c0f <free_pages>
  104ba6:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  104ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bac:	83 c0 04             	add    $0x4,%eax
  104baf:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104bb6:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104bb9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104bbc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104bbf:	0f a3 10             	bt     %edx,(%eax)
  104bc2:	19 c0                	sbb    %eax,%eax
  104bc4:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104bc7:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104bcb:	0f 95 c0             	setne  %al
  104bce:	0f b6 c0             	movzbl %al,%eax
  104bd1:	85 c0                	test   %eax,%eax
  104bd3:	74 0b                	je     104be0 <default_check+0x344>
  104bd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bd8:	8b 40 08             	mov    0x8(%eax),%eax
  104bdb:	83 f8 01             	cmp    $0x1,%eax
  104bde:	74 19                	je     104bf9 <default_check+0x35d>
  104be0:	68 04 69 10 00       	push   $0x106904
  104be5:	68 7e 66 10 00       	push   $0x10667e
  104bea:	68 fa 00 00 00       	push   $0xfa
  104bef:	68 93 66 10 00       	push   $0x106693
  104bf4:	e8 d9 b7 ff ff       	call   1003d2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104bfc:	83 c0 04             	add    $0x4,%eax
  104bff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104c06:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c09:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c0c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104c0f:	0f a3 10             	bt     %edx,(%eax)
  104c12:	19 c0                	sbb    %eax,%eax
  104c14:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104c17:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104c1b:	0f 95 c0             	setne  %al
  104c1e:	0f b6 c0             	movzbl %al,%eax
  104c21:	85 c0                	test   %eax,%eax
  104c23:	74 0b                	je     104c30 <default_check+0x394>
  104c25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104c28:	8b 40 08             	mov    0x8(%eax),%eax
  104c2b:	83 f8 03             	cmp    $0x3,%eax
  104c2e:	74 19                	je     104c49 <default_check+0x3ad>
  104c30:	68 2c 69 10 00       	push   $0x10692c
  104c35:	68 7e 66 10 00       	push   $0x10667e
  104c3a:	68 fb 00 00 00       	push   $0xfb
  104c3f:	68 93 66 10 00       	push   $0x106693
  104c44:	e8 89 b7 ff ff       	call   1003d2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104c49:	83 ec 0c             	sub    $0xc,%esp
  104c4c:	6a 01                	push   $0x1
  104c4e:	e8 7e df ff ff       	call   102bd1 <alloc_pages>
  104c53:	83 c4 10             	add    $0x10,%esp
  104c56:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104c59:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104c5c:	83 e8 14             	sub    $0x14,%eax
  104c5f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104c62:	74 19                	je     104c7d <default_check+0x3e1>
  104c64:	68 52 69 10 00       	push   $0x106952
  104c69:	68 7e 66 10 00       	push   $0x10667e
  104c6e:	68 fd 00 00 00       	push   $0xfd
  104c73:	68 93 66 10 00       	push   $0x106693
  104c78:	e8 55 b7 ff ff       	call   1003d2 <__panic>
    free_page(p0);
  104c7d:	83 ec 08             	sub    $0x8,%esp
  104c80:	6a 01                	push   $0x1
  104c82:	ff 75 dc             	pushl  -0x24(%ebp)
  104c85:	e8 85 df ff ff       	call   102c0f <free_pages>
  104c8a:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104c8d:	83 ec 0c             	sub    $0xc,%esp
  104c90:	6a 02                	push   $0x2
  104c92:	e8 3a df ff ff       	call   102bd1 <alloc_pages>
  104c97:	83 c4 10             	add    $0x10,%esp
  104c9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104c9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104ca0:	83 c0 14             	add    $0x14,%eax
  104ca3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104ca6:	74 19                	je     104cc1 <default_check+0x425>
  104ca8:	68 70 69 10 00       	push   $0x106970
  104cad:	68 7e 66 10 00       	push   $0x10667e
  104cb2:	68 ff 00 00 00       	push   $0xff
  104cb7:	68 93 66 10 00       	push   $0x106693
  104cbc:	e8 11 b7 ff ff       	call   1003d2 <__panic>

    free_pages(p0, 2);
  104cc1:	83 ec 08             	sub    $0x8,%esp
  104cc4:	6a 02                	push   $0x2
  104cc6:	ff 75 dc             	pushl  -0x24(%ebp)
  104cc9:	e8 41 df ff ff       	call   102c0f <free_pages>
  104cce:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104cd1:	83 ec 08             	sub    $0x8,%esp
  104cd4:	6a 01                	push   $0x1
  104cd6:	ff 75 c0             	pushl  -0x40(%ebp)
  104cd9:	e8 31 df ff ff       	call   102c0f <free_pages>
  104cde:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  104ce1:	83 ec 0c             	sub    $0xc,%esp
  104ce4:	6a 05                	push   $0x5
  104ce6:	e8 e6 de ff ff       	call   102bd1 <alloc_pages>
  104ceb:	83 c4 10             	add    $0x10,%esp
  104cee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104cf1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104cf5:	75 19                	jne    104d10 <default_check+0x474>
  104cf7:	68 90 69 10 00       	push   $0x106990
  104cfc:	68 7e 66 10 00       	push   $0x10667e
  104d01:	68 04 01 00 00       	push   $0x104
  104d06:	68 93 66 10 00       	push   $0x106693
  104d0b:	e8 c2 b6 ff ff       	call   1003d2 <__panic>
    assert(alloc_page() == NULL);
  104d10:	83 ec 0c             	sub    $0xc,%esp
  104d13:	6a 01                	push   $0x1
  104d15:	e8 b7 de ff ff       	call   102bd1 <alloc_pages>
  104d1a:	83 c4 10             	add    $0x10,%esp
  104d1d:	85 c0                	test   %eax,%eax
  104d1f:	74 19                	je     104d3a <default_check+0x49e>
  104d21:	68 ee 67 10 00       	push   $0x1067ee
  104d26:	68 7e 66 10 00       	push   $0x10667e
  104d2b:	68 05 01 00 00       	push   $0x105
  104d30:	68 93 66 10 00       	push   $0x106693
  104d35:	e8 98 b6 ff ff       	call   1003d2 <__panic>

    assert(nr_free == 0);
  104d3a:	a1 64 89 11 00       	mov    0x118964,%eax
  104d3f:	85 c0                	test   %eax,%eax
  104d41:	74 19                	je     104d5c <default_check+0x4c0>
  104d43:	68 41 68 10 00       	push   $0x106841
  104d48:	68 7e 66 10 00       	push   $0x10667e
  104d4d:	68 07 01 00 00       	push   $0x107
  104d52:	68 93 66 10 00       	push   $0x106693
  104d57:	e8 76 b6 ff ff       	call   1003d2 <__panic>
    nr_free = nr_free_store;
  104d5c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104d5f:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  104d64:	8b 45 80             	mov    -0x80(%ebp),%eax
  104d67:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104d6a:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104d6f:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  104d75:	83 ec 08             	sub    $0x8,%esp
  104d78:	6a 05                	push   $0x5
  104d7a:	ff 75 dc             	pushl  -0x24(%ebp)
  104d7d:	e8 8d de ff ff       	call   102c0f <free_pages>
  104d82:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  104d85:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104d8c:	eb 1d                	jmp    104dab <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  104d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d91:	83 e8 0c             	sub    $0xc,%eax
  104d94:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  104d97:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104d9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104d9e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104da1:	8b 40 08             	mov    0x8(%eax),%eax
  104da4:	29 c2                	sub    %eax,%edx
  104da6:	89 d0                	mov    %edx,%eax
  104da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dae:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104db1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104db4:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104dba:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104dc1:	75 cb                	jne    104d8e <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  104dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104dc7:	74 19                	je     104de2 <default_check+0x546>
  104dc9:	68 ae 69 10 00       	push   $0x1069ae
  104dce:	68 7e 66 10 00       	push   $0x10667e
  104dd3:	68 12 01 00 00       	push   $0x112
  104dd8:	68 93 66 10 00       	push   $0x106693
  104ddd:	e8 f0 b5 ff ff       	call   1003d2 <__panic>
    assert(total == 0);
  104de2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104de6:	74 19                	je     104e01 <default_check+0x565>
  104de8:	68 b9 69 10 00       	push   $0x1069b9
  104ded:	68 7e 66 10 00       	push   $0x10667e
  104df2:	68 13 01 00 00       	push   $0x113
  104df7:	68 93 66 10 00       	push   $0x106693
  104dfc:	e8 d1 b5 ff ff       	call   1003d2 <__panic>
}
  104e01:	90                   	nop
  104e02:	c9                   	leave  
  104e03:	c3                   	ret    

00104e04 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  104e04:	55                   	push   %ebp
  104e05:	89 e5                	mov    %esp,%ebp
  104e07:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104e0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  104e11:	eb 04                	jmp    104e17 <strlen+0x13>
        cnt ++;
  104e13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  104e17:	8b 45 08             	mov    0x8(%ebp),%eax
  104e1a:	8d 50 01             	lea    0x1(%eax),%edx
  104e1d:	89 55 08             	mov    %edx,0x8(%ebp)
  104e20:	0f b6 00             	movzbl (%eax),%eax
  104e23:	84 c0                	test   %al,%al
  104e25:	75 ec                	jne    104e13 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  104e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104e2a:	c9                   	leave  
  104e2b:	c3                   	ret    

00104e2c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  104e2c:	55                   	push   %ebp
  104e2d:	89 e5                	mov    %esp,%ebp
  104e2f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104e32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  104e39:	eb 04                	jmp    104e3f <strnlen+0x13>
        cnt ++;
  104e3b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  104e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104e42:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e45:	73 10                	jae    104e57 <strnlen+0x2b>
  104e47:	8b 45 08             	mov    0x8(%ebp),%eax
  104e4a:	8d 50 01             	lea    0x1(%eax),%edx
  104e4d:	89 55 08             	mov    %edx,0x8(%ebp)
  104e50:	0f b6 00             	movzbl (%eax),%eax
  104e53:	84 c0                	test   %al,%al
  104e55:	75 e4                	jne    104e3b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  104e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104e5a:	c9                   	leave  
  104e5b:	c3                   	ret    

00104e5c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  104e5c:	55                   	push   %ebp
  104e5d:	89 e5                	mov    %esp,%ebp
  104e5f:	57                   	push   %edi
  104e60:	56                   	push   %esi
  104e61:	83 ec 20             	sub    $0x20,%esp
  104e64:	8b 45 08             	mov    0x8(%ebp),%eax
  104e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  104e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  104e70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e76:	89 d1                	mov    %edx,%ecx
  104e78:	89 c2                	mov    %eax,%edx
  104e7a:	89 ce                	mov    %ecx,%esi
  104e7c:	89 d7                	mov    %edx,%edi
  104e7e:	ac                   	lods   %ds:(%esi),%al
  104e7f:	aa                   	stos   %al,%es:(%edi)
  104e80:	84 c0                	test   %al,%al
  104e82:	75 fa                	jne    104e7e <strcpy+0x22>
  104e84:	89 fa                	mov    %edi,%edx
  104e86:	89 f1                	mov    %esi,%ecx
  104e88:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  104e8b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  104e8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  104e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  104e94:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  104e95:	83 c4 20             	add    $0x20,%esp
  104e98:	5e                   	pop    %esi
  104e99:	5f                   	pop    %edi
  104e9a:	5d                   	pop    %ebp
  104e9b:	c3                   	ret    

00104e9c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  104e9c:	55                   	push   %ebp
  104e9d:	89 e5                	mov    %esp,%ebp
  104e9f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  104ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  104ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  104ea8:	eb 21                	jmp    104ecb <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  104eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ead:	0f b6 10             	movzbl (%eax),%edx
  104eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104eb3:	88 10                	mov    %dl,(%eax)
  104eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104eb8:	0f b6 00             	movzbl (%eax),%eax
  104ebb:	84 c0                	test   %al,%al
  104ebd:	74 04                	je     104ec3 <strncpy+0x27>
            src ++;
  104ebf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  104ec3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  104ec7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  104ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104ecf:	75 d9                	jne    104eaa <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  104ed1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  104ed4:	c9                   	leave  
  104ed5:	c3                   	ret    

00104ed6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  104ed6:	55                   	push   %ebp
  104ed7:	89 e5                	mov    %esp,%ebp
  104ed9:	57                   	push   %edi
  104eda:	56                   	push   %esi
  104edb:	83 ec 20             	sub    $0x20,%esp
  104ede:	8b 45 08             	mov    0x8(%ebp),%eax
  104ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  104eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef0:	89 d1                	mov    %edx,%ecx
  104ef2:	89 c2                	mov    %eax,%edx
  104ef4:	89 ce                	mov    %ecx,%esi
  104ef6:	89 d7                	mov    %edx,%edi
  104ef8:	ac                   	lods   %ds:(%esi),%al
  104ef9:	ae                   	scas   %es:(%edi),%al
  104efa:	75 08                	jne    104f04 <strcmp+0x2e>
  104efc:	84 c0                	test   %al,%al
  104efe:	75 f8                	jne    104ef8 <strcmp+0x22>
  104f00:	31 c0                	xor    %eax,%eax
  104f02:	eb 04                	jmp    104f08 <strcmp+0x32>
  104f04:	19 c0                	sbb    %eax,%eax
  104f06:	0c 01                	or     $0x1,%al
  104f08:	89 fa                	mov    %edi,%edx
  104f0a:	89 f1                	mov    %esi,%ecx
  104f0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f0f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  104f12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  104f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  104f18:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  104f19:	83 c4 20             	add    $0x20,%esp
  104f1c:	5e                   	pop    %esi
  104f1d:	5f                   	pop    %edi
  104f1e:	5d                   	pop    %ebp
  104f1f:	c3                   	ret    

00104f20 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  104f20:	55                   	push   %ebp
  104f21:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  104f23:	eb 0c                	jmp    104f31 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  104f25:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  104f29:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  104f2d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  104f31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104f35:	74 1a                	je     104f51 <strncmp+0x31>
  104f37:	8b 45 08             	mov    0x8(%ebp),%eax
  104f3a:	0f b6 00             	movzbl (%eax),%eax
  104f3d:	84 c0                	test   %al,%al
  104f3f:	74 10                	je     104f51 <strncmp+0x31>
  104f41:	8b 45 08             	mov    0x8(%ebp),%eax
  104f44:	0f b6 10             	movzbl (%eax),%edx
  104f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  104f4a:	0f b6 00             	movzbl (%eax),%eax
  104f4d:	38 c2                	cmp    %al,%dl
  104f4f:	74 d4                	je     104f25 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  104f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104f55:	74 18                	je     104f6f <strncmp+0x4f>
  104f57:	8b 45 08             	mov    0x8(%ebp),%eax
  104f5a:	0f b6 00             	movzbl (%eax),%eax
  104f5d:	0f b6 d0             	movzbl %al,%edx
  104f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  104f63:	0f b6 00             	movzbl (%eax),%eax
  104f66:	0f b6 c0             	movzbl %al,%eax
  104f69:	29 c2                	sub    %eax,%edx
  104f6b:	89 d0                	mov    %edx,%eax
  104f6d:	eb 05                	jmp    104f74 <strncmp+0x54>
  104f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104f74:	5d                   	pop    %ebp
  104f75:	c3                   	ret    

00104f76 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  104f76:	55                   	push   %ebp
  104f77:	89 e5                	mov    %esp,%ebp
  104f79:	83 ec 04             	sub    $0x4,%esp
  104f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  104f7f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  104f82:	eb 14                	jmp    104f98 <strchr+0x22>
        if (*s == c) {
  104f84:	8b 45 08             	mov    0x8(%ebp),%eax
  104f87:	0f b6 00             	movzbl (%eax),%eax
  104f8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  104f8d:	75 05                	jne    104f94 <strchr+0x1e>
            return (char *)s;
  104f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  104f92:	eb 13                	jmp    104fa7 <strchr+0x31>
        }
        s ++;
  104f94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  104f98:	8b 45 08             	mov    0x8(%ebp),%eax
  104f9b:	0f b6 00             	movzbl (%eax),%eax
  104f9e:	84 c0                	test   %al,%al
  104fa0:	75 e2                	jne    104f84 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  104fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104fa7:	c9                   	leave  
  104fa8:	c3                   	ret    

00104fa9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  104fa9:	55                   	push   %ebp
  104faa:	89 e5                	mov    %esp,%ebp
  104fac:	83 ec 04             	sub    $0x4,%esp
  104faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  104fb2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  104fb5:	eb 0f                	jmp    104fc6 <strfind+0x1d>
        if (*s == c) {
  104fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  104fba:	0f b6 00             	movzbl (%eax),%eax
  104fbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  104fc0:	74 10                	je     104fd2 <strfind+0x29>
            break;
        }
        s ++;
  104fc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  104fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  104fc9:	0f b6 00             	movzbl (%eax),%eax
  104fcc:	84 c0                	test   %al,%al
  104fce:	75 e7                	jne    104fb7 <strfind+0xe>
  104fd0:	eb 01                	jmp    104fd3 <strfind+0x2a>
        if (*s == c) {
            break;
  104fd2:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  104fd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  104fd6:	c9                   	leave  
  104fd7:	c3                   	ret    

00104fd8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  104fd8:	55                   	push   %ebp
  104fd9:	89 e5                	mov    %esp,%ebp
  104fdb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  104fde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  104fe5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  104fec:	eb 04                	jmp    104ff2 <strtol+0x1a>
        s ++;
  104fee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  104ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  104ff5:	0f b6 00             	movzbl (%eax),%eax
  104ff8:	3c 20                	cmp    $0x20,%al
  104ffa:	74 f2                	je     104fee <strtol+0x16>
  104ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  104fff:	0f b6 00             	movzbl (%eax),%eax
  105002:	3c 09                	cmp    $0x9,%al
  105004:	74 e8                	je     104fee <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105006:	8b 45 08             	mov    0x8(%ebp),%eax
  105009:	0f b6 00             	movzbl (%eax),%eax
  10500c:	3c 2b                	cmp    $0x2b,%al
  10500e:	75 06                	jne    105016 <strtol+0x3e>
        s ++;
  105010:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105014:	eb 15                	jmp    10502b <strtol+0x53>
    }
    else if (*s == '-') {
  105016:	8b 45 08             	mov    0x8(%ebp),%eax
  105019:	0f b6 00             	movzbl (%eax),%eax
  10501c:	3c 2d                	cmp    $0x2d,%al
  10501e:	75 0b                	jne    10502b <strtol+0x53>
        s ++, neg = 1;
  105020:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105024:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10502b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10502f:	74 06                	je     105037 <strtol+0x5f>
  105031:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105035:	75 24                	jne    10505b <strtol+0x83>
  105037:	8b 45 08             	mov    0x8(%ebp),%eax
  10503a:	0f b6 00             	movzbl (%eax),%eax
  10503d:	3c 30                	cmp    $0x30,%al
  10503f:	75 1a                	jne    10505b <strtol+0x83>
  105041:	8b 45 08             	mov    0x8(%ebp),%eax
  105044:	83 c0 01             	add    $0x1,%eax
  105047:	0f b6 00             	movzbl (%eax),%eax
  10504a:	3c 78                	cmp    $0x78,%al
  10504c:	75 0d                	jne    10505b <strtol+0x83>
        s += 2, base = 16;
  10504e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105052:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105059:	eb 2a                	jmp    105085 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10505b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10505f:	75 17                	jne    105078 <strtol+0xa0>
  105061:	8b 45 08             	mov    0x8(%ebp),%eax
  105064:	0f b6 00             	movzbl (%eax),%eax
  105067:	3c 30                	cmp    $0x30,%al
  105069:	75 0d                	jne    105078 <strtol+0xa0>
        s ++, base = 8;
  10506b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10506f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105076:	eb 0d                	jmp    105085 <strtol+0xad>
    }
    else if (base == 0) {
  105078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10507c:	75 07                	jne    105085 <strtol+0xad>
        base = 10;
  10507e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105085:	8b 45 08             	mov    0x8(%ebp),%eax
  105088:	0f b6 00             	movzbl (%eax),%eax
  10508b:	3c 2f                	cmp    $0x2f,%al
  10508d:	7e 1b                	jle    1050aa <strtol+0xd2>
  10508f:	8b 45 08             	mov    0x8(%ebp),%eax
  105092:	0f b6 00             	movzbl (%eax),%eax
  105095:	3c 39                	cmp    $0x39,%al
  105097:	7f 11                	jg     1050aa <strtol+0xd2>
            dig = *s - '0';
  105099:	8b 45 08             	mov    0x8(%ebp),%eax
  10509c:	0f b6 00             	movzbl (%eax),%eax
  10509f:	0f be c0             	movsbl %al,%eax
  1050a2:	83 e8 30             	sub    $0x30,%eax
  1050a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050a8:	eb 48                	jmp    1050f2 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1050aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1050ad:	0f b6 00             	movzbl (%eax),%eax
  1050b0:	3c 60                	cmp    $0x60,%al
  1050b2:	7e 1b                	jle    1050cf <strtol+0xf7>
  1050b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1050b7:	0f b6 00             	movzbl (%eax),%eax
  1050ba:	3c 7a                	cmp    $0x7a,%al
  1050bc:	7f 11                	jg     1050cf <strtol+0xf7>
            dig = *s - 'a' + 10;
  1050be:	8b 45 08             	mov    0x8(%ebp),%eax
  1050c1:	0f b6 00             	movzbl (%eax),%eax
  1050c4:	0f be c0             	movsbl %al,%eax
  1050c7:	83 e8 57             	sub    $0x57,%eax
  1050ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050cd:	eb 23                	jmp    1050f2 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1050cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1050d2:	0f b6 00             	movzbl (%eax),%eax
  1050d5:	3c 40                	cmp    $0x40,%al
  1050d7:	7e 3c                	jle    105115 <strtol+0x13d>
  1050d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1050dc:	0f b6 00             	movzbl (%eax),%eax
  1050df:	3c 5a                	cmp    $0x5a,%al
  1050e1:	7f 32                	jg     105115 <strtol+0x13d>
            dig = *s - 'A' + 10;
  1050e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1050e6:	0f b6 00             	movzbl (%eax),%eax
  1050e9:	0f be c0             	movsbl %al,%eax
  1050ec:	83 e8 37             	sub    $0x37,%eax
  1050ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  1050f8:	7d 1a                	jge    105114 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  1050fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1050fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105101:	0f af 45 10          	imul   0x10(%ebp),%eax
  105105:	89 c2                	mov    %eax,%edx
  105107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10510a:	01 d0                	add    %edx,%eax
  10510c:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10510f:	e9 71 ff ff ff       	jmp    105085 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105114:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105119:	74 08                	je     105123 <strtol+0x14b>
        *endptr = (char *) s;
  10511b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10511e:	8b 55 08             	mov    0x8(%ebp),%edx
  105121:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105123:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105127:	74 07                	je     105130 <strtol+0x158>
  105129:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10512c:	f7 d8                	neg    %eax
  10512e:	eb 03                	jmp    105133 <strtol+0x15b>
  105130:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105133:	c9                   	leave  
  105134:	c3                   	ret    

00105135 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105135:	55                   	push   %ebp
  105136:	89 e5                	mov    %esp,%ebp
  105138:	57                   	push   %edi
  105139:	83 ec 24             	sub    $0x24,%esp
  10513c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10513f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105142:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105146:	8b 55 08             	mov    0x8(%ebp),%edx
  105149:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10514c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10514f:	8b 45 10             	mov    0x10(%ebp),%eax
  105152:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105158:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10515c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10515f:	89 d7                	mov    %edx,%edi
  105161:	f3 aa                	rep stos %al,%es:(%edi)
  105163:	89 fa                	mov    %edi,%edx
  105165:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105168:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10516b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10516e:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10516f:	83 c4 24             	add    $0x24,%esp
  105172:	5f                   	pop    %edi
  105173:	5d                   	pop    %ebp
  105174:	c3                   	ret    

00105175 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105175:	55                   	push   %ebp
  105176:	89 e5                	mov    %esp,%ebp
  105178:	57                   	push   %edi
  105179:	56                   	push   %esi
  10517a:	53                   	push   %ebx
  10517b:	83 ec 30             	sub    $0x30,%esp
  10517e:	8b 45 08             	mov    0x8(%ebp),%eax
  105181:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105184:	8b 45 0c             	mov    0xc(%ebp),%eax
  105187:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10518a:	8b 45 10             	mov    0x10(%ebp),%eax
  10518d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105193:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105196:	73 42                	jae    1051da <memmove+0x65>
  105198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10519b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10519e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1051a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1051aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051ad:	c1 e8 02             	shr    $0x2,%eax
  1051b0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1051b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1051b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051b8:	89 d7                	mov    %edx,%edi
  1051ba:	89 c6                	mov    %eax,%esi
  1051bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1051be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051c1:	83 e1 03             	and    $0x3,%ecx
  1051c4:	74 02                	je     1051c8 <memmove+0x53>
  1051c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1051c8:	89 f0                	mov    %esi,%eax
  1051ca:	89 fa                	mov    %edi,%edx
  1051cc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1051cf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1051d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1051d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1051d8:	eb 36                	jmp    105210 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1051da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1051e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051e3:	01 c2                	add    %eax,%edx
  1051e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051e8:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1051eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051ee:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1051f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051f4:	89 c1                	mov    %eax,%ecx
  1051f6:	89 d8                	mov    %ebx,%eax
  1051f8:	89 d6                	mov    %edx,%esi
  1051fa:	89 c7                	mov    %eax,%edi
  1051fc:	fd                   	std    
  1051fd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1051ff:	fc                   	cld    
  105200:	89 f8                	mov    %edi,%eax
  105202:	89 f2                	mov    %esi,%edx
  105204:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105207:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10520a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  10520d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105210:	83 c4 30             	add    $0x30,%esp
  105213:	5b                   	pop    %ebx
  105214:	5e                   	pop    %esi
  105215:	5f                   	pop    %edi
  105216:	5d                   	pop    %ebp
  105217:	c3                   	ret    

00105218 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105218:	55                   	push   %ebp
  105219:	89 e5                	mov    %esp,%ebp
  10521b:	57                   	push   %edi
  10521c:	56                   	push   %esi
  10521d:	83 ec 20             	sub    $0x20,%esp
  105220:	8b 45 08             	mov    0x8(%ebp),%eax
  105223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105226:	8b 45 0c             	mov    0xc(%ebp),%eax
  105229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10522c:	8b 45 10             	mov    0x10(%ebp),%eax
  10522f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105235:	c1 e8 02             	shr    $0x2,%eax
  105238:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10523a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10523d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105240:	89 d7                	mov    %edx,%edi
  105242:	89 c6                	mov    %eax,%esi
  105244:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105246:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105249:	83 e1 03             	and    $0x3,%ecx
  10524c:	74 02                	je     105250 <memcpy+0x38>
  10524e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105250:	89 f0                	mov    %esi,%eax
  105252:	89 fa                	mov    %edi,%edx
  105254:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105257:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10525a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10525d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  105260:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105261:	83 c4 20             	add    $0x20,%esp
  105264:	5e                   	pop    %esi
  105265:	5f                   	pop    %edi
  105266:	5d                   	pop    %ebp
  105267:	c3                   	ret    

00105268 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105268:	55                   	push   %ebp
  105269:	89 e5                	mov    %esp,%ebp
  10526b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10526e:	8b 45 08             	mov    0x8(%ebp),%eax
  105271:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105274:	8b 45 0c             	mov    0xc(%ebp),%eax
  105277:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10527a:	eb 30                	jmp    1052ac <memcmp+0x44>
        if (*s1 != *s2) {
  10527c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10527f:	0f b6 10             	movzbl (%eax),%edx
  105282:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105285:	0f b6 00             	movzbl (%eax),%eax
  105288:	38 c2                	cmp    %al,%dl
  10528a:	74 18                	je     1052a4 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10528c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10528f:	0f b6 00             	movzbl (%eax),%eax
  105292:	0f b6 d0             	movzbl %al,%edx
  105295:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105298:	0f b6 00             	movzbl (%eax),%eax
  10529b:	0f b6 c0             	movzbl %al,%eax
  10529e:	29 c2                	sub    %eax,%edx
  1052a0:	89 d0                	mov    %edx,%eax
  1052a2:	eb 1a                	jmp    1052be <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1052a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1052a8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1052ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1052af:	8d 50 ff             	lea    -0x1(%eax),%edx
  1052b2:	89 55 10             	mov    %edx,0x10(%ebp)
  1052b5:	85 c0                	test   %eax,%eax
  1052b7:	75 c3                	jne    10527c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1052b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052be:	c9                   	leave  
  1052bf:	c3                   	ret    

001052c0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1052c0:	55                   	push   %ebp
  1052c1:	89 e5                	mov    %esp,%ebp
  1052c3:	83 ec 38             	sub    $0x38,%esp
  1052c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1052c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1052cc:	8b 45 14             	mov    0x14(%ebp),%eax
  1052cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1052d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1052d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052db:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1052de:	8b 45 18             	mov    0x18(%ebp),%eax
  1052e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1052ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052ed:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1052f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1052fa:	74 1c                	je     105318 <printnum+0x58>
  1052fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052ff:	ba 00 00 00 00       	mov    $0x0,%edx
  105304:	f7 75 e4             	divl   -0x1c(%ebp)
  105307:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10530a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10530d:	ba 00 00 00 00       	mov    $0x0,%edx
  105312:	f7 75 e4             	divl   -0x1c(%ebp)
  105315:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10531b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10531e:	f7 75 e4             	divl   -0x1c(%ebp)
  105321:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105324:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10532a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10532d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105330:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105333:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105336:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105339:	8b 45 18             	mov    0x18(%ebp),%eax
  10533c:	ba 00 00 00 00       	mov    $0x0,%edx
  105341:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105344:	77 41                	ja     105387 <printnum+0xc7>
  105346:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105349:	72 05                	jb     105350 <printnum+0x90>
  10534b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10534e:	77 37                	ja     105387 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105350:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105353:	83 e8 01             	sub    $0x1,%eax
  105356:	83 ec 04             	sub    $0x4,%esp
  105359:	ff 75 20             	pushl  0x20(%ebp)
  10535c:	50                   	push   %eax
  10535d:	ff 75 18             	pushl  0x18(%ebp)
  105360:	ff 75 ec             	pushl  -0x14(%ebp)
  105363:	ff 75 e8             	pushl  -0x18(%ebp)
  105366:	ff 75 0c             	pushl  0xc(%ebp)
  105369:	ff 75 08             	pushl  0x8(%ebp)
  10536c:	e8 4f ff ff ff       	call   1052c0 <printnum>
  105371:	83 c4 20             	add    $0x20,%esp
  105374:	eb 1b                	jmp    105391 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105376:	83 ec 08             	sub    $0x8,%esp
  105379:	ff 75 0c             	pushl  0xc(%ebp)
  10537c:	ff 75 20             	pushl  0x20(%ebp)
  10537f:	8b 45 08             	mov    0x8(%ebp),%eax
  105382:	ff d0                	call   *%eax
  105384:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105387:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10538b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10538f:	7f e5                	jg     105376 <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105391:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105394:	05 74 6a 10 00       	add    $0x106a74,%eax
  105399:	0f b6 00             	movzbl (%eax),%eax
  10539c:	0f be c0             	movsbl %al,%eax
  10539f:	83 ec 08             	sub    $0x8,%esp
  1053a2:	ff 75 0c             	pushl  0xc(%ebp)
  1053a5:	50                   	push   %eax
  1053a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a9:	ff d0                	call   *%eax
  1053ab:	83 c4 10             	add    $0x10,%esp
}
  1053ae:	90                   	nop
  1053af:	c9                   	leave  
  1053b0:	c3                   	ret    

001053b1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1053b1:	55                   	push   %ebp
  1053b2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053b8:	7e 14                	jle    1053ce <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1053ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1053bd:	8b 00                	mov    (%eax),%eax
  1053bf:	8d 48 08             	lea    0x8(%eax),%ecx
  1053c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1053c5:	89 0a                	mov    %ecx,(%edx)
  1053c7:	8b 50 04             	mov    0x4(%eax),%edx
  1053ca:	8b 00                	mov    (%eax),%eax
  1053cc:	eb 30                	jmp    1053fe <getuint+0x4d>
    }
    else if (lflag) {
  1053ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053d2:	74 16                	je     1053ea <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1053d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d7:	8b 00                	mov    (%eax),%eax
  1053d9:	8d 48 04             	lea    0x4(%eax),%ecx
  1053dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1053df:	89 0a                	mov    %ecx,(%edx)
  1053e1:	8b 00                	mov    (%eax),%eax
  1053e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1053e8:	eb 14                	jmp    1053fe <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1053ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ed:	8b 00                	mov    (%eax),%eax
  1053ef:	8d 48 04             	lea    0x4(%eax),%ecx
  1053f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1053f5:	89 0a                	mov    %ecx,(%edx)
  1053f7:	8b 00                	mov    (%eax),%eax
  1053f9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1053fe:	5d                   	pop    %ebp
  1053ff:	c3                   	ret    

00105400 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105400:	55                   	push   %ebp
  105401:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105403:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105407:	7e 14                	jle    10541d <getint+0x1d>
        return va_arg(*ap, long long);
  105409:	8b 45 08             	mov    0x8(%ebp),%eax
  10540c:	8b 00                	mov    (%eax),%eax
  10540e:	8d 48 08             	lea    0x8(%eax),%ecx
  105411:	8b 55 08             	mov    0x8(%ebp),%edx
  105414:	89 0a                	mov    %ecx,(%edx)
  105416:	8b 50 04             	mov    0x4(%eax),%edx
  105419:	8b 00                	mov    (%eax),%eax
  10541b:	eb 28                	jmp    105445 <getint+0x45>
    }
    else if (lflag) {
  10541d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105421:	74 12                	je     105435 <getint+0x35>
        return va_arg(*ap, long);
  105423:	8b 45 08             	mov    0x8(%ebp),%eax
  105426:	8b 00                	mov    (%eax),%eax
  105428:	8d 48 04             	lea    0x4(%eax),%ecx
  10542b:	8b 55 08             	mov    0x8(%ebp),%edx
  10542e:	89 0a                	mov    %ecx,(%edx)
  105430:	8b 00                	mov    (%eax),%eax
  105432:	99                   	cltd   
  105433:	eb 10                	jmp    105445 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105435:	8b 45 08             	mov    0x8(%ebp),%eax
  105438:	8b 00                	mov    (%eax),%eax
  10543a:	8d 48 04             	lea    0x4(%eax),%ecx
  10543d:	8b 55 08             	mov    0x8(%ebp),%edx
  105440:	89 0a                	mov    %ecx,(%edx)
  105442:	8b 00                	mov    (%eax),%eax
  105444:	99                   	cltd   
    }
}
  105445:	5d                   	pop    %ebp
  105446:	c3                   	ret    

00105447 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105447:	55                   	push   %ebp
  105448:	89 e5                	mov    %esp,%ebp
  10544a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  10544d:	8d 45 14             	lea    0x14(%ebp),%eax
  105450:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105456:	50                   	push   %eax
  105457:	ff 75 10             	pushl  0x10(%ebp)
  10545a:	ff 75 0c             	pushl  0xc(%ebp)
  10545d:	ff 75 08             	pushl  0x8(%ebp)
  105460:	e8 06 00 00 00       	call   10546b <vprintfmt>
  105465:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  105468:	90                   	nop
  105469:	c9                   	leave  
  10546a:	c3                   	ret    

0010546b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10546b:	55                   	push   %ebp
  10546c:	89 e5                	mov    %esp,%ebp
  10546e:	56                   	push   %esi
  10546f:	53                   	push   %ebx
  105470:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105473:	eb 17                	jmp    10548c <vprintfmt+0x21>
            if (ch == '\0') {
  105475:	85 db                	test   %ebx,%ebx
  105477:	0f 84 8e 03 00 00    	je     10580b <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  10547d:	83 ec 08             	sub    $0x8,%esp
  105480:	ff 75 0c             	pushl  0xc(%ebp)
  105483:	53                   	push   %ebx
  105484:	8b 45 08             	mov    0x8(%ebp),%eax
  105487:	ff d0                	call   *%eax
  105489:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10548c:	8b 45 10             	mov    0x10(%ebp),%eax
  10548f:	8d 50 01             	lea    0x1(%eax),%edx
  105492:	89 55 10             	mov    %edx,0x10(%ebp)
  105495:	0f b6 00             	movzbl (%eax),%eax
  105498:	0f b6 d8             	movzbl %al,%ebx
  10549b:	83 fb 25             	cmp    $0x25,%ebx
  10549e:	75 d5                	jne    105475 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1054a0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1054a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1054ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1054b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1054b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1054be:	8b 45 10             	mov    0x10(%ebp),%eax
  1054c1:	8d 50 01             	lea    0x1(%eax),%edx
  1054c4:	89 55 10             	mov    %edx,0x10(%ebp)
  1054c7:	0f b6 00             	movzbl (%eax),%eax
  1054ca:	0f b6 d8             	movzbl %al,%ebx
  1054cd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1054d0:	83 f8 55             	cmp    $0x55,%eax
  1054d3:	0f 87 05 03 00 00    	ja     1057de <vprintfmt+0x373>
  1054d9:	8b 04 85 98 6a 10 00 	mov    0x106a98(,%eax,4),%eax
  1054e0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1054e2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1054e6:	eb d6                	jmp    1054be <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1054e8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1054ec:	eb d0                	jmp    1054be <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1054f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054f8:	89 d0                	mov    %edx,%eax
  1054fa:	c1 e0 02             	shl    $0x2,%eax
  1054fd:	01 d0                	add    %edx,%eax
  1054ff:	01 c0                	add    %eax,%eax
  105501:	01 d8                	add    %ebx,%eax
  105503:	83 e8 30             	sub    $0x30,%eax
  105506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105509:	8b 45 10             	mov    0x10(%ebp),%eax
  10550c:	0f b6 00             	movzbl (%eax),%eax
  10550f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105512:	83 fb 2f             	cmp    $0x2f,%ebx
  105515:	7e 39                	jle    105550 <vprintfmt+0xe5>
  105517:	83 fb 39             	cmp    $0x39,%ebx
  10551a:	7f 34                	jg     105550 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10551c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105520:	eb d3                	jmp    1054f5 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105522:	8b 45 14             	mov    0x14(%ebp),%eax
  105525:	8d 50 04             	lea    0x4(%eax),%edx
  105528:	89 55 14             	mov    %edx,0x14(%ebp)
  10552b:	8b 00                	mov    (%eax),%eax
  10552d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105530:	eb 1f                	jmp    105551 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  105532:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105536:	79 86                	jns    1054be <vprintfmt+0x53>
                width = 0;
  105538:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10553f:	e9 7a ff ff ff       	jmp    1054be <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105544:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10554b:	e9 6e ff ff ff       	jmp    1054be <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105550:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105551:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105555:	0f 89 63 ff ff ff    	jns    1054be <vprintfmt+0x53>
                width = precision, precision = -1;
  10555b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10555e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105561:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105568:	e9 51 ff ff ff       	jmp    1054be <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10556d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105571:	e9 48 ff ff ff       	jmp    1054be <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105576:	8b 45 14             	mov    0x14(%ebp),%eax
  105579:	8d 50 04             	lea    0x4(%eax),%edx
  10557c:	89 55 14             	mov    %edx,0x14(%ebp)
  10557f:	8b 00                	mov    (%eax),%eax
  105581:	83 ec 08             	sub    $0x8,%esp
  105584:	ff 75 0c             	pushl  0xc(%ebp)
  105587:	50                   	push   %eax
  105588:	8b 45 08             	mov    0x8(%ebp),%eax
  10558b:	ff d0                	call   *%eax
  10558d:	83 c4 10             	add    $0x10,%esp
            break;
  105590:	e9 71 02 00 00       	jmp    105806 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105595:	8b 45 14             	mov    0x14(%ebp),%eax
  105598:	8d 50 04             	lea    0x4(%eax),%edx
  10559b:	89 55 14             	mov    %edx,0x14(%ebp)
  10559e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1055a0:	85 db                	test   %ebx,%ebx
  1055a2:	79 02                	jns    1055a6 <vprintfmt+0x13b>
                err = -err;
  1055a4:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1055a6:	83 fb 06             	cmp    $0x6,%ebx
  1055a9:	7f 0b                	jg     1055b6 <vprintfmt+0x14b>
  1055ab:	8b 34 9d 58 6a 10 00 	mov    0x106a58(,%ebx,4),%esi
  1055b2:	85 f6                	test   %esi,%esi
  1055b4:	75 19                	jne    1055cf <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1055b6:	53                   	push   %ebx
  1055b7:	68 85 6a 10 00       	push   $0x106a85
  1055bc:	ff 75 0c             	pushl  0xc(%ebp)
  1055bf:	ff 75 08             	pushl  0x8(%ebp)
  1055c2:	e8 80 fe ff ff       	call   105447 <printfmt>
  1055c7:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1055ca:	e9 37 02 00 00       	jmp    105806 <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1055cf:	56                   	push   %esi
  1055d0:	68 8e 6a 10 00       	push   $0x106a8e
  1055d5:	ff 75 0c             	pushl  0xc(%ebp)
  1055d8:	ff 75 08             	pushl  0x8(%ebp)
  1055db:	e8 67 fe ff ff       	call   105447 <printfmt>
  1055e0:	83 c4 10             	add    $0x10,%esp
            }
            break;
  1055e3:	e9 1e 02 00 00       	jmp    105806 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1055e8:	8b 45 14             	mov    0x14(%ebp),%eax
  1055eb:	8d 50 04             	lea    0x4(%eax),%edx
  1055ee:	89 55 14             	mov    %edx,0x14(%ebp)
  1055f1:	8b 30                	mov    (%eax),%esi
  1055f3:	85 f6                	test   %esi,%esi
  1055f5:	75 05                	jne    1055fc <vprintfmt+0x191>
                p = "(null)";
  1055f7:	be 91 6a 10 00       	mov    $0x106a91,%esi
            }
            if (width > 0 && padc != '-') {
  1055fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105600:	7e 76                	jle    105678 <vprintfmt+0x20d>
  105602:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105606:	74 70                	je     105678 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10560b:	83 ec 08             	sub    $0x8,%esp
  10560e:	50                   	push   %eax
  10560f:	56                   	push   %esi
  105610:	e8 17 f8 ff ff       	call   104e2c <strnlen>
  105615:	83 c4 10             	add    $0x10,%esp
  105618:	89 c2                	mov    %eax,%edx
  10561a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10561d:	29 d0                	sub    %edx,%eax
  10561f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105622:	eb 17                	jmp    10563b <vprintfmt+0x1d0>
                    putch(padc, putdat);
  105624:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105628:	83 ec 08             	sub    $0x8,%esp
  10562b:	ff 75 0c             	pushl  0xc(%ebp)
  10562e:	50                   	push   %eax
  10562f:	8b 45 08             	mov    0x8(%ebp),%eax
  105632:	ff d0                	call   *%eax
  105634:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105637:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10563b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10563f:	7f e3                	jg     105624 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105641:	eb 35                	jmp    105678 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  105643:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105647:	74 1c                	je     105665 <vprintfmt+0x1fa>
  105649:	83 fb 1f             	cmp    $0x1f,%ebx
  10564c:	7e 05                	jle    105653 <vprintfmt+0x1e8>
  10564e:	83 fb 7e             	cmp    $0x7e,%ebx
  105651:	7e 12                	jle    105665 <vprintfmt+0x1fa>
                    putch('?', putdat);
  105653:	83 ec 08             	sub    $0x8,%esp
  105656:	ff 75 0c             	pushl  0xc(%ebp)
  105659:	6a 3f                	push   $0x3f
  10565b:	8b 45 08             	mov    0x8(%ebp),%eax
  10565e:	ff d0                	call   *%eax
  105660:	83 c4 10             	add    $0x10,%esp
  105663:	eb 0f                	jmp    105674 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  105665:	83 ec 08             	sub    $0x8,%esp
  105668:	ff 75 0c             	pushl  0xc(%ebp)
  10566b:	53                   	push   %ebx
  10566c:	8b 45 08             	mov    0x8(%ebp),%eax
  10566f:	ff d0                	call   *%eax
  105671:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105674:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105678:	89 f0                	mov    %esi,%eax
  10567a:	8d 70 01             	lea    0x1(%eax),%esi
  10567d:	0f b6 00             	movzbl (%eax),%eax
  105680:	0f be d8             	movsbl %al,%ebx
  105683:	85 db                	test   %ebx,%ebx
  105685:	74 26                	je     1056ad <vprintfmt+0x242>
  105687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10568b:	78 b6                	js     105643 <vprintfmt+0x1d8>
  10568d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105695:	79 ac                	jns    105643 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105697:	eb 14                	jmp    1056ad <vprintfmt+0x242>
                putch(' ', putdat);
  105699:	83 ec 08             	sub    $0x8,%esp
  10569c:	ff 75 0c             	pushl  0xc(%ebp)
  10569f:	6a 20                	push   $0x20
  1056a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a4:	ff d0                	call   *%eax
  1056a6:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056a9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056b1:	7f e6                	jg     105699 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1056b3:	e9 4e 01 00 00       	jmp    105806 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1056b8:	83 ec 08             	sub    $0x8,%esp
  1056bb:	ff 75 e0             	pushl  -0x20(%ebp)
  1056be:	8d 45 14             	lea    0x14(%ebp),%eax
  1056c1:	50                   	push   %eax
  1056c2:	e8 39 fd ff ff       	call   105400 <getint>
  1056c7:	83 c4 10             	add    $0x10,%esp
  1056ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1056d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056d6:	85 d2                	test   %edx,%edx
  1056d8:	79 23                	jns    1056fd <vprintfmt+0x292>
                putch('-', putdat);
  1056da:	83 ec 08             	sub    $0x8,%esp
  1056dd:	ff 75 0c             	pushl  0xc(%ebp)
  1056e0:	6a 2d                	push   $0x2d
  1056e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e5:	ff d0                	call   *%eax
  1056e7:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  1056ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056f0:	f7 d8                	neg    %eax
  1056f2:	83 d2 00             	adc    $0x0,%edx
  1056f5:	f7 da                	neg    %edx
  1056f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1056fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105704:	e9 9f 00 00 00       	jmp    1057a8 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105709:	83 ec 08             	sub    $0x8,%esp
  10570c:	ff 75 e0             	pushl  -0x20(%ebp)
  10570f:	8d 45 14             	lea    0x14(%ebp),%eax
  105712:	50                   	push   %eax
  105713:	e8 99 fc ff ff       	call   1053b1 <getuint>
  105718:	83 c4 10             	add    $0x10,%esp
  10571b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10571e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105721:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105728:	eb 7e                	jmp    1057a8 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10572a:	83 ec 08             	sub    $0x8,%esp
  10572d:	ff 75 e0             	pushl  -0x20(%ebp)
  105730:	8d 45 14             	lea    0x14(%ebp),%eax
  105733:	50                   	push   %eax
  105734:	e8 78 fc ff ff       	call   1053b1 <getuint>
  105739:	83 c4 10             	add    $0x10,%esp
  10573c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10573f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105742:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105749:	eb 5d                	jmp    1057a8 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  10574b:	83 ec 08             	sub    $0x8,%esp
  10574e:	ff 75 0c             	pushl  0xc(%ebp)
  105751:	6a 30                	push   $0x30
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	ff d0                	call   *%eax
  105758:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  10575b:	83 ec 08             	sub    $0x8,%esp
  10575e:	ff 75 0c             	pushl  0xc(%ebp)
  105761:	6a 78                	push   $0x78
  105763:	8b 45 08             	mov    0x8(%ebp),%eax
  105766:	ff d0                	call   *%eax
  105768:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10576b:	8b 45 14             	mov    0x14(%ebp),%eax
  10576e:	8d 50 04             	lea    0x4(%eax),%edx
  105771:	89 55 14             	mov    %edx,0x14(%ebp)
  105774:	8b 00                	mov    (%eax),%eax
  105776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105780:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105787:	eb 1f                	jmp    1057a8 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105789:	83 ec 08             	sub    $0x8,%esp
  10578c:	ff 75 e0             	pushl  -0x20(%ebp)
  10578f:	8d 45 14             	lea    0x14(%ebp),%eax
  105792:	50                   	push   %eax
  105793:	e8 19 fc ff ff       	call   1053b1 <getuint>
  105798:	83 c4 10             	add    $0x10,%esp
  10579b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10579e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1057a1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1057a8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1057ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057af:	83 ec 04             	sub    $0x4,%esp
  1057b2:	52                   	push   %edx
  1057b3:	ff 75 e8             	pushl  -0x18(%ebp)
  1057b6:	50                   	push   %eax
  1057b7:	ff 75 f4             	pushl  -0xc(%ebp)
  1057ba:	ff 75 f0             	pushl  -0x10(%ebp)
  1057bd:	ff 75 0c             	pushl  0xc(%ebp)
  1057c0:	ff 75 08             	pushl  0x8(%ebp)
  1057c3:	e8 f8 fa ff ff       	call   1052c0 <printnum>
  1057c8:	83 c4 20             	add    $0x20,%esp
            break;
  1057cb:	eb 39                	jmp    105806 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1057cd:	83 ec 08             	sub    $0x8,%esp
  1057d0:	ff 75 0c             	pushl  0xc(%ebp)
  1057d3:	53                   	push   %ebx
  1057d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d7:	ff d0                	call   *%eax
  1057d9:	83 c4 10             	add    $0x10,%esp
            break;
  1057dc:	eb 28                	jmp    105806 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1057de:	83 ec 08             	sub    $0x8,%esp
  1057e1:	ff 75 0c             	pushl  0xc(%ebp)
  1057e4:	6a 25                	push   $0x25
  1057e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e9:	ff d0                	call   *%eax
  1057eb:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  1057ee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057f2:	eb 04                	jmp    1057f8 <vprintfmt+0x38d>
  1057f4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1057fb:	83 e8 01             	sub    $0x1,%eax
  1057fe:	0f b6 00             	movzbl (%eax),%eax
  105801:	3c 25                	cmp    $0x25,%al
  105803:	75 ef                	jne    1057f4 <vprintfmt+0x389>
                /* do nothing */;
            break;
  105805:	90                   	nop
        }
    }
  105806:	e9 68 fc ff ff       	jmp    105473 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10580b:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10580c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10580f:	5b                   	pop    %ebx
  105810:	5e                   	pop    %esi
  105811:	5d                   	pop    %ebp
  105812:	c3                   	ret    

00105813 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105813:	55                   	push   %ebp
  105814:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105816:	8b 45 0c             	mov    0xc(%ebp),%eax
  105819:	8b 40 08             	mov    0x8(%eax),%eax
  10581c:	8d 50 01             	lea    0x1(%eax),%edx
  10581f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105822:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105825:	8b 45 0c             	mov    0xc(%ebp),%eax
  105828:	8b 10                	mov    (%eax),%edx
  10582a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582d:	8b 40 04             	mov    0x4(%eax),%eax
  105830:	39 c2                	cmp    %eax,%edx
  105832:	73 12                	jae    105846 <sprintputch+0x33>
        *b->buf ++ = ch;
  105834:	8b 45 0c             	mov    0xc(%ebp),%eax
  105837:	8b 00                	mov    (%eax),%eax
  105839:	8d 48 01             	lea    0x1(%eax),%ecx
  10583c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10583f:	89 0a                	mov    %ecx,(%edx)
  105841:	8b 55 08             	mov    0x8(%ebp),%edx
  105844:	88 10                	mov    %dl,(%eax)
    }
}
  105846:	90                   	nop
  105847:	5d                   	pop    %ebp
  105848:	c3                   	ret    

00105849 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105849:	55                   	push   %ebp
  10584a:	89 e5                	mov    %esp,%ebp
  10584c:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10584f:	8d 45 14             	lea    0x14(%ebp),%eax
  105852:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105858:	50                   	push   %eax
  105859:	ff 75 10             	pushl  0x10(%ebp)
  10585c:	ff 75 0c             	pushl  0xc(%ebp)
  10585f:	ff 75 08             	pushl  0x8(%ebp)
  105862:	e8 0b 00 00 00       	call   105872 <vsnprintf>
  105867:	83 c4 10             	add    $0x10,%esp
  10586a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10586d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105870:	c9                   	leave  
  105871:	c3                   	ret    

00105872 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105872:	55                   	push   %ebp
  105873:	89 e5                	mov    %esp,%ebp
  105875:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105878:	8b 45 08             	mov    0x8(%ebp),%eax
  10587b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10587e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105881:	8d 50 ff             	lea    -0x1(%eax),%edx
  105884:	8b 45 08             	mov    0x8(%ebp),%eax
  105887:	01 d0                	add    %edx,%eax
  105889:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10588c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105897:	74 0a                	je     1058a3 <vsnprintf+0x31>
  105899:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10589c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10589f:	39 c2                	cmp    %eax,%edx
  1058a1:	76 07                	jbe    1058aa <vsnprintf+0x38>
        return -E_INVAL;
  1058a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1058a8:	eb 20                	jmp    1058ca <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1058aa:	ff 75 14             	pushl  0x14(%ebp)
  1058ad:	ff 75 10             	pushl  0x10(%ebp)
  1058b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1058b3:	50                   	push   %eax
  1058b4:	68 13 58 10 00       	push   $0x105813
  1058b9:	e8 ad fb ff ff       	call   10546b <vprintfmt>
  1058be:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  1058c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058c4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1058c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058ca:	c9                   	leave  
  1058cb:	c3                   	ret    
