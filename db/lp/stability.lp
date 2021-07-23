%=============================================================================
% A and B are two instances of the same library. Can B replace A?
%=============================================================================

% These might be useful
is_symbol(Symbol) :- abi_typelocation(_, Symbol, _, _, _, _).
is_register(Register) :- abi_typelocation(_, _, _, _, Register, _).
is_direction(Direction) :- abi_typelocation(_, _, _, _, _, Direction).
is_type(Type) :- abi_typelocation(_, _, _, Type, _, _).


% Let Exported(BinSet) be a set of interface/type/locations triples exported by a set of binaries
% Let Imported(BinSet) be a set of interface/type/location triples imported by some binary
% Mark symbols as exported or imported for each library
% We assume that we don't miss params based on name because the types/locations are unique
exported_A(Symbol, Type, Register) :- 
    is_a(Symbol, Type, Register, "export").

imported_A(Symbol, Type, Register) :- 
    is_a(Symbol, Type, Register, "import").

exported_B(Symbol, Type, Register) :- 
    is_b(Symbol, Type, Register, "export").

imported_B(Symbol, Type, Register) :- 
    is_b(Symbol, Type, Register, "import").


% Let Dependencies(Bin) be the set of binaries that binary Bin depends on. 
% We don't have this represented yet?

% - We’ll say B can safely replace A if: Exported({A}) is a subset of Exported({B})
% This also says that there can't be any symbols in A not in B
missing_exports(Symbol, Type, Register) :-

    % The symbol is exported for A
    exported_A(Symbol, Type, Register),
    
    % And it's exported for B
    not exported_B(Symbol, Type, Register).


% -and- Imported({B}) is a subset of Imported({A}) U Exported(Dependencies(B))
missing_imports(Symbol, Type, Register) :-

    % The symbol is exported for A
    imported_A(Symbol, Type, Register),
    
    % And it's exported for B
    not imported_B(Symbol, Type, Register).
           
#show missing_imports/3.
#show missing_exports/3.
#show is_a/4.
#show is_b/4.
#show is_symbol/1.
#show is_register/1.
#show is_type/1.
#show is_direction/1.
#show exported_A/3.
#show exported_B/3.
#show imported_A/3.
#show imported_B/3.
