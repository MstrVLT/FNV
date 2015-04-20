unit uFNV;

interface

function fnv(dwOffset : Pointer; dwLen : NativeUInt; offset_basis: NativeUInt) : NativeUInt ; assembler; register;

implementation

function fnv(dwOffset : Pointer; dwLen : NativeUInt; offset_basis: NativeUInt) : NativeUInt ; assembler; register;
//
// http://find.fnvhash.com/ - FNV Hash Calculator Online
// http://www.isthe.com/chongo/tech/comp/fnv/
//
// function fnv32(dwOffset : PByteArray; dwLen : DWORD; offset_basis: DWORD): DWORD ;
// var i: integer;
// begin
//   result := offset_basis;
//   for i := 0 to dwLen-1 do
//     result := (result*16777619) xor DWORD(dwOffset^[i]);
// end;
//
// The offset_basis for FNV-1 is dependent on n, the size of the hash:
//
// 32 bit offset_basis = 2166136261
// 64 bit offset_basis = 14695981039346656037
//
{$IF Defined(CPUX86)}
asm
    push ebp
    push edi
    push ebx // statement must preserve the EDI, ESI, ESP, EBP, and EBX registers
    mov ebp, edx
    mov edx, ecx // but can freely modify the EAX, ECX, and EDX registers
    mov ecx, eax
    mov eax, edx
    mov edi, 01000193h
    xor ebx, ebx
  @@nexta:
    mov bl, byte ptr [ecx]
    xor eax, ebx
    mul edi
    inc ecx
    dec ebp
    jnz @@nexta
    pop ebx
    pop edi
    pop ebp
end;
{$ELSEIF Defined(CPUX64)}
asm
    mov rax, R8
    mov r8, rdx
    mov r9, 100000001b3h
    xor r10, r10
  @@nexta:
    mov r10b, byte ptr [rcx]
    xor rax, r10
    mul r9
    inc rcx
    dec r8
    jnz @@nexta
end;
{$IFEND}

end.
