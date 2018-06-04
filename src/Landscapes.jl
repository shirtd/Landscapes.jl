__precompile__(true)

module Landscapes

    struct Landscape
        x::Array{Float64,2}
        t::Array{Float64,1}
        k::Int
    end

    top!(D) = (m = findmax(D); D[m[2]] = -Inf; m[1])
    topk(D,k;l=[]) = k > 0 ? topk(D,k-1,l=push!(l,top!(D))) : l

    function Landscape(D::Array{Float64,2},T; k=10)
        L = map(t->topk([maximum([minimum([t-D[i,1],D[i,2]-t]),0]) for i=1:size(D,1)],k),T)
        Landscape([L[i][j] for j=1:k,i=1:length(T)],collect(T),k)
    end

    Base.getindex(L::Landscape,k::Int,t::Float64) = L.x[k,t]
    Base.getindex(L::Landscape,k::Int) = L.x[k,:]
    Base.mean(Ls::Array{Landscape,1}) = sum(map(L->L.x,Ls))/length(Ls)

    export Landscape, mean

end
